
-----------------------------------------------------------------------------------
--pr_balancete_saldo_plano_conta
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000
--Autor (es)          : Carlos Cardoso Fernandes         
--Banco Dados         : EGISSQL
--Objetivo            : Total do Balancete de Verificação pelo Saldo do Plano de Contas
--Data                : 30.12.2004
--Atualizado          : 
-----------------------------------------------------------------------------------
create procedure pr_total_balancete_verificacao
@ic_parametro             int,
@dt_inicial               datetime,
@dt_final                 datetime
as

------------------------------------------------------------------------------------
--Parâmetros--
------------------------------------------------------------------------------------
-- 1--> Total do balancete do período ativo
-- 2--> Total do balancete de período não ativo
------------------------------------------------------------------------------------

--select * from parametro_contabilidade
--select * from plano_conta

--Busca o Nível do Balancete na Tabela de Parametros

declare @qt_nivel_balancete int
set @qt_nivel_balancete = 0

select
  @qt_nivel_balancete = isnull(qt_nivel_balancete,1)
from
  Parametro_Contabilidade
where
  cd_empresa = dbo.fn_empresa()


--Executa a soma das contas

if @ic_parametro=1
begin

  select
    cd_empresa,
    case when isnull(p.ic_saldo_inicial_conta,'') = 'D' then
              cast( isnull(p.vl_saldo_inicial_conta,0.00)  as decimal(15,2))  end as 'vl_saldo_inicial_debito',

    case when isnull(p.ic_saldo_inicial_conta,'') = 'C' then
              cast( isnull(p.vl_saldo_inicial_conta,0.00)  as decimal(15,2))  end as 'vl_saldo_inicial_credito',

    cast( isnull(p.vl_debito_conta,0.00)                   as decimal(15,2))      as 'vl_debito_conta',
    cast( isnull(p.vl_credito_conta,0.00)                  as decimal(15,2))      as 'vl_credito_conta',
 
    case when isnull(p.ic_saldo_atual_conta,'') = 'D' then   
              cast( isnull(p.vl_saldo_atual_conta,0.00)    as decimal(15,2))  end as 'vl_saldo_atual_debito',

    case when isnull(p.ic_saldo_atual_conta,'') = 'C' then   
              cast( isnull(p.vl_saldo_atual_conta,0.00)    as decimal(15,2))  end as 'vl_saldo_atual_credito'

  into
    #soma
  from
    Plano_conta p
  where
    p.qt_grau_conta = @qt_nivel_balancete


  select
    sum( isnull(vl_saldo_inicial_debito,0) )  as vl_saldo_inicial_debito,
    sum( isnull(vl_saldo_inicial_credito,0) ) as vl_saldo_inicial_credito,
    sum( isnull(vl_debito_conta         ,0) ) as vl_debito_conta,
    sum( isnull(vl_credito_conta        ,0) ) as vl_credito_conta,
    sum( isnull(vl_saldo_atual_debito   ,0) ) as vl_saldo_atual_debito,
    sum( isnull(vl_saldo_atual_credito  ,0) ) as vl_saldo_atual_credito
  from
    #soma
  group by
     cd_empresa

end

