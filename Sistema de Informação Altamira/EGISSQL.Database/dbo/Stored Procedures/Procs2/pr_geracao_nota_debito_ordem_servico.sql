
-------------------------------------------------------------------------------
--pr_geracao_nota_debito_ordem_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 17.12.2005
--Alteração        : 19.12.2005 - Valor Total - Carlos Fernandes 
--                 : 03.01.2006 - Atualização do Número da Nota Débito na OS - Carlos Fernandes
--                 : 06.02.2006 - Forma de geração - Carlos Fernandes.
-----------------------------------------------------------------------------------------------
create procedure pr_geracao_nota_debito_ordem_servico
@cd_ordem_servico int = 0,
@cd_usuario       int = 0,
@ic_tipo_geracao  char(1) = '' --A:Analítica / S:Sintética
as

--select * from ordem_servico_analista
--select * from nota_debito_despesa
--sp_help nota_debito_despesa
--select * from ordem_servico_analista_despesa

if @cd_ordem_servico>0
begin

  declare @Tabela                 varchar(50)
  declare @cd_nota_debito_despesa int
  declare @vl_nota_debito         float
  declare @cd_item_despesa_ordem  int 

  set @Tabela = cast(DB_NAME()+'.dbo.Nota_Debito_Despesa' as varchar(50))

  --Gera o Código da Nota de Débito de Despesa

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_nota_debito_despesa', @codigo = @cd_nota_debito_despesa output	     
 
  select
    top 1
    @cd_nota_debito_despesa as cd_nota_debito_despesa,
    getdate()               as dt_nota_debito_despesa,
    null                    as dt_inicio_ref_nota_debito,
    null                    as dt_final_ref_nota_debito,
    osa.cd_cliente,
    null                    as nm_ref_nota_debito,
    null                    as nm_obs_ref_nota_debito,
    null                    as vl_nota_debito,
    ' '                     as ds_nota_debito,
    null                    as cd_conta_banco,
    null                    as dt_baixa_nota_debito,
    null                    as dt_pagto_nota_debito,
    'N'                     as ic_emitida_nota_debito,
    @cd_usuario             as cd_usuario,
    getdate()               as dt_usuario,
    null                    as cd_projeto,
    osa.cd_pedido_venda, 
    osa.cd_contato,
    'N'                     as ic_scr_gerado,
    getdate()               as dt_vencimento_nota_debito,
    osa.cd_centro_custo,
    osa.cd_analista,
    null                    as cd_identificacao_cliente
  into
    #ND
  from
    Ordem_Servico_Analista osa
    left outer join ordem_servico_analista_despesa osap on osap.cd_ordem_servico = osa.cd_ordem_servico
  where
    osa.cd_ordem_servico                  = @cd_ordem_servico and
    isnull(osa.ic_nota_debito,'N')        = 'N'     and
    isnull(osap.cd_nota_debito_despesa,0) = 0
  
  --select * from #ND

  if exists( select top 1 cd_nota_debito_despesa from #ND ) 
  begin

    --print 'aqui'

    insert into Nota_Debito_Despesa
      select * from #ND

    --montagem da tabela nota_debito_despesa_composicao

    select 
     @cd_nota_debito_despesa as cd_nota_debito_despesa,
     cd_item_despesa_ordem   as cd_item_nota_despesa,
     cd_tipo_despesa,
     qt_item_despesa_ordem   as qt_nota_debito,
     vl_item_despesa_ordem   as vl_item_nota_debito,
     nm_obs_tipo_despesa     as nm_obs_item_nota_debito,
     @cd_usuario             as cd_usuario, 
     dt_usuario,
     dt_despesa,
     cd_documento_despesa,
     ic_empresa_despesa,
     ic_cliente_despesa,
     ic_consultor_despesa
   into
     #NDC
   from 
     ordem_servico_analista_despesa
   where 
     cd_ordem_servico = @cd_ordem_servico and
     isnull(ic_cliente_despesa,'N') = 'S' and
     isnull(cd_nota_debito_despesa,0)=0       --Verifica se foi Gerado a Nota Débito

--    select * from #NDC
    
    insert into nota_debito_despesa_composicao
      select * from #NDC
   	
    --Cálculo do Valor Total
    set @vl_nota_debito = 0

    select
      @vl_nota_debito = sum(qt_nota_debito * vl_item_nota_debito)
    from
     #NDC
    where
     cd_nota_debito_despesa = @cd_nota_debito_despesa

    --Atualiza o Total da Nota Débito
    --select * from nota_debito_despesa

    update
      Nota_Debito_Despesa
    set
      vl_nota_debito = @vl_nota_debito
    where
       cd_nota_debito_despesa = @cd_nota_debito_despesa

    --Atualiza o flag de Geração na Ordem Serviço
    
    update
      Ordem_servico_Analista
     set
      ic_nota_debito = 'S'
     where
      cd_ordem_servico = @cd_ordem_servico

     --Atualiza o Número da Nota Débito na Tabela de Ordem de Serviço Gerada
     --select * from #NDC
 
      while exists ( select top 1 cd_nota_debito_despesa from #NDC )
      begin

--        print @cd_nota_debito_despesa

        select 
          top 1
           @cd_nota_debito_despesa = cd_nota_debito_despesa,
           @cd_item_despesa_ordem  = cd_item_nota_despesa
          from
            #NDC
 
        update
          ordem_servico_analista_despesa
        set
          cd_nota_debito_despesa = @cd_nota_debito_despesa
        where
           @cd_ordem_servico       = cd_ordem_servico and
           @cd_item_despesa_ordem  = cd_item_despesa_ordem
 
        delete from #NDC 
        where
           @cd_nota_debito_despesa = cd_nota_debito_despesa and
           @cd_item_despesa_ordem  = cd_item_nota_despesa
 
      end

-- select * from ordem_servico_analista_despesa
     
   end

  -- limpeza da tabela de código
   exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_nota_debito_despesa, 'D'

end

