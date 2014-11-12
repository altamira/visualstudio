
-----------------------------------------------------------------------------------
--pr_balancete_saldo_plano_conta
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000
--Autor (es)          : Carlos Cardoso Fernandes         
--Banco Dados         : EGISSQL
--Objetivo            : Balancete de Verificação pelo Saldo do Plano de Contas
--Data                : 30.12.2004
--Atualizado          : 
-----------------------------------------------------------------------------------
create procedure pr_balancete_saldo_plano_conta
@ic_parametro             int,
@ic_imprime_sem_movimento char(1),
@cd_empresa               int,
@cd_exercicio             int,
@dt_inicial               datetime,
@dt_final                 datetime
as

--select * from plano_conta

  select
    p.cd_conta,
    p.cd_conta_reduzido,
    p.cd_conta_sintetica,
    p.cd_grupo_conta,
    p.qt_grau_conta,
    p.cd_mascara_conta,
    p.nm_conta,
    cast( isnull(p.vl_saldo_inicial_conta,0.00) as decimal(15,2)) as 'vl_saldo_inicial',
          isnull(p.ic_saldo_inicial_conta,'')                     as 'ic_saldo_inicial',
    cast( isnull(p.vl_debito_conta,0.00)        as decimal(15,2)) as 'vl_debito_conta',
    cast( isnull(p.vl_credito_conta,0.00)       as decimal(15,2)) as 'vl_credito_conta',
    cast( isnull(p.vl_saldo_atual_conta,0.00)   as decimal(15,2)) as 'vl_saldo_atual',
          isnull(p.ic_saldo_atual_conta,'')                       as 'ic_saldo_atual',
          isnull(qt_lancamento_conta,0)                           as 'qt_lancamento',
    p.ic_conta_analitica,
    p.ic_tipo_conta,
    g.ic_tipo_grupo_conta
  into 
    #BalanceteContabil
  from
    Plano_conta p, 
    Grupo_conta g
  where
    p.cd_empresa     = @cd_empresa and
    p.cd_grupo_conta = g.cd_grupo_conta

-----------------------------------------------------------------------------------------
--Apresentação do Balancete de Verificação
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------
if @ic_parametro = 1                     -- Balancete de Verificação Completo
-----------------------------------------------------------------------------
begin

  if @ic_imprime_sem_movimento = 'S'
     begin  
    
       select 
         * 
       from 
         #BalanceteContabil 
       order by 
         cd_mascara_conta

     end
   else
     begin

       select 
         * 
       from 
         #BalanceteContabil 
       where
         vl_saldo_inicial <> 0 or
         vl_saldo_atual <> 0
       order by 
         cd_mascara_conta
     end
        
end

-----------------------------------------------------------------------------
if @ic_parametro = 2                             -- Somente Contas Analíticas
-----------------------------------------------------------------------------
begin

  if @ic_imprime_sem_movimento = 'S'
  begin  
    
    select 
      * 
    from 
      #BalanceteContabil 
    where
      ic_conta_analitica = 'a'  
    order by 
     cd_mascara_conta

   end
   else
      begin

        select 
          * 
        from 
          #BalanceteContabil 
        where
          ic_conta_analitica = 'a' and
          vl_saldo_inicial <> 0 or
          vl_saldo_atual <> 0
        order by 
          cd_mascara_conta
       end
        
   end
       


