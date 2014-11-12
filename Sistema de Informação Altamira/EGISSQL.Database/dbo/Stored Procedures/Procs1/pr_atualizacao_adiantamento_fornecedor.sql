
--sp_helptext pr_atualizacao_adiantamento_fornecedor
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2007
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Atualização do Adiantamento do Fornecedor
--Data           : 25.04.2006
--Atualizado     : 25.04.2006
--               : 01.05.2007
--               : 17.05.2007
--               : 23.05.2007
--               : 28.05.2007
--               : 09.10.2007 - Verificação da Gravação dos Registros - Carlos Fernandes
-- 19.05.2009 - Complemento dos Campos - Carlos Fernandes
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_atualizacao_adiantamento_fornecedor
@ic_parametro            int      = 0,
@cd_fornecedor           int      = 0,
@cd_item_adto_fornecedor int      = 0,
@cd_usuario              int      = 0,
@cd_plano_financeiro     int      = 0,
@cd_conta_banco          int      = 0,
@cd_tipo_caixa           int      = 0

as


  declare @cd_lancamento             int 
  declare @cd_lancamento_caixa       int 
  declare @cd_ap                     int
  declare @cd_item_ap                int 
  declare @vl_ap                     float
  declare @ds_ap                     varchar(8000)
  declare @dt_ap                     datetime

  set @dt_ap = cast(convert(varchar(10),getdate(),103) as datetime)

if @ic_parametro = 1

begin

--select * from fornecedor_adiantamento

  declare @Tabela		     varchar(50)

  --Geração da Autorização de Pagamento
  
  --Verifica se existe a Ap e Deleta

  select
    @cd_ap = isnull(cd_ap,0)
  from
    autorizacao_pagamento   with (nolock) 
   where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor 

  if @cd_ap>0 
  begin

    update 
      fornecedor_adiantamento
    set 
      cd_ap = 0
    from 
      fornecedor_adiantamento fa 
    where 
      fa.cd_ap = @cd_ap  

    delete from autorizacao_pagto_composicao where cd_ap = @cd_ap

    delete from autorizacao_pagamento        where cd_ap = @cd_ap

  end

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Autorizacao_Pagamento' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
	
  while exists(Select top 1 'x' from autorizacao_pagamento where cd_ap = @cd_ap)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'
  end
 
 
  select 
    @vl_ap    = isnull(vl_adto_fornecedor,0),
    @ds_ap    = 'Adiantamento a Fornecedores : '+cast(cd_item_adto_fornecedor as varchar)
    --@cd_moeda = cd_moeda
  from
    fornecedor_adiantamento with (nolock) 
  where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor and
    isnull(cd_ap,0)         = 0

   --select @vl_ap  

   --Atualização do Adiantamento
     
   update
     fornecedor_adiantamento
   set
     cd_ap = @cd_ap
   where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor 

------------------------------------------------------------------------------
--Geração da AP
------------------------------------------------------------------------------
--select * from tipo_autorizacao_pagamento
--select * from autorizacao_pagamento
--select * from autorizacao_pagto_composicao

  select
    @cd_ap                   as cd_ap,
    @dt_ap                   as dt_ap,
    @ds_ap                   as ds_ap,
    null                     as dt_aprovacao_ap,
    @vl_ap                   as vl_ap,
    @cd_usuario              as cd_usuario,
    getdate()                as dt_usuario,
    null                     as cd_usuario_aprovacao,
    7                        as cd_tipo_ap,
    null                     as cd_cheque_pagar,
    null                     as cd_requisicao_viagem,
    null                     as cd_solicitacao,
    null                     as cd_funcionario,
    @cd_fornecedor           as cd_fornecedor,
    null                     as cd_documento_pagar,
    null                     as cd_prestacao,
    @cd_item_adto_fornecedor as cd_item_adto_fornecedor,
    null                     as dt_pagamento_ap,
    null                     as cd_controle_folha

  into
    #ap

  insert into 
    autorizacao_pagamento
  select
    *
  from
    #ap

  --composicao

  select
     @cd_ap                                  as cd_ap,
     fa.cd_item_adto_fornecedor              as cd_item_ap,
     null                                    as cd_tipo_documento,
     fa.cd_item_adto_fornecedor              as cd_documento_ap,
     @cd_usuario                             as cd_usuario,
     getdate()                               as dt_usuario,
     'A'                                     as ic_tipo_documento_ap,
     isnull(d.cd_identificacao_document,
           'AF: '+cast(cd_item_adto_fornecedor as varchar)) as cd_identificacao_documento
   into
     #autorizacao_pagto_composicao
   from
     fornecedor_adiantamento fa        with (nolock) 
     left outer join documento_pagar d with (nolock) on d.cd_documento_pagar = fa.cd_documento_pagar
   where
    fa.cd_fornecedor           = @cd_fornecedor            and
    fa.cd_item_adto_fornecedor = @cd_item_adto_fornecedor 

  --select * from #autorizacao_pagto_composicao
 
   insert into
     autorizacao_pagto_composicao 
   select
     *
   from
     #autorizacao_pagto_composicao

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'

---------------------------------------------------------------------------------------------------
--Geração do Movimento Bancário
---------------------------------------------------------------------------------------------------

if @cd_conta_banco>0
begin

  select
    @cd_lancamento = isnull(cd_lancamento,0)
  from
    fornecedor_adiantamento with (nolock) 
  where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor

  --Deleta o Lançamento Anterior

  delete from conta_banco_lancamento where cd_lancamento = @cd_lancamento

  --select * from conta_banco_lancamento  
  --select * from tipo_operacao_bancaria
  --select * from tipo_lancamento_fluxo

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Conta_Banco_Lancamento' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output
	
  while exists(Select top 1 'x' from conta_banco_lancamento where cd_lancamento = @cd_lancamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'
  end

  select
    @cd_lancamento                          as cd_lancamento,
    @dt_ap                                  as dt_lancamento,
    @vl_ap                                  as vl_lancamento,
    'Adiantamento Fornecedor : '+
    (select top 1 f.nm_fantasia_fornecedor
     from
       fornecedor f 
     where 
       f.cd_fornecedor = @cd_fornecedor )   as nm_historico_lancamento,
     @cd_conta_banco                        as cd_conta_banco,
     @cd_plano_financeiro                   as cd_plano_financeiro,
     2                                      as cd_tipo_operacao,
     null                                   as cd_historico_financeiro,
     1                                      as cd_moeda,
     @cd_usuario                            as cd_usuario,
     getdate()                              as dt_usuario,
     2                                      as cd_tipo_lancamento_fluxo,
     'N'                                    as ic_lancamento_conciliado,
     'N'                                    as ic_transferencia_conta,
     dbo.fn_empresa()                       as cd_empresa,
     null                                   as cd_documento,
     null                                   as cd_documento_baixa,
     null                                   as cd_lancamento_padrao,
     null                                   as cd_documento_receber,
     null                                   as dt_contabilizacao,
     null                                   as cd_lancamento_contabil,
     null                                   as cd_lote,
     null                                   as cd_conta_credito,
     null                                   as cd_conta_debito,
     null                                   as cd_dac_conta_banco,
     'S'                                    as ic_fluxo_caixa,
     'N'                                    as ic_manual_lancamento,
     null                                   as nm_compl_lancamento

   into
     #conta_banco_lancamento

   insert into
     conta_banco_lancamento
   select
     * 
   from
     #conta_banco_lancamento

   drop table #conta_banco_lancamento

   exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'

   update
     fornecedor_adiantamento
   set
     cd_lancamento = @cd_lancamento
   where
     cd_fornecedor           = @cd_fornecedor and
     cd_item_adto_fornecedor = @cd_item_adto_fornecedor


end

---------------------------------------------------------------------------------------------------
--Geração do Movimento de Caixa
---------------------------------------------------------------------------------------------------

if @cd_tipo_caixa>0
begin

  select
    @cd_lancamento_caixa = isnull(cd_lancamento_caixa,0)
  from
    fornecedor_adiantamento with (nolock) 
  where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor
  

  delete from caixa_lancamento where cd_lancamento_caixa = @cd_lancamento_caixa

  --select * from caixa_lancamento

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Caixa_Lancamento' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_caixa', @codigo = @cd_lancamento_caixa output
	
  while exists(Select top 1 'x' from caixa_lancamento where cd_lancamento_caixa = @cd_lancamento_caixa)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_caixa', @codigo = @cd_lancamento_caixa output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_caixa, 'D'
  end

  
  select
    @cd_lancamento_caixa                    as cd_lancamento_caixa,
    1                                       as cd_tipo_operacao,
    @dt_ap                                  as dt_lancamento_caixa,
    @vl_ap                                  as vl_lancamento_caixa,
    @cd_item_adto_fornecedor                as cd_documento_lancamento,
    'Adiantamento Fornecedor : '+
    (select top 1 f.nm_fantasia_fornecedor
     from
       fornecedor f 
     where 
       f.cd_fornecedor = @cd_fornecedor )   as nm_historico_lancamento,
     @cd_tipo_caixa                         as cd_tipo_caixa,
     @cd_plano_financeiro                   as cd_plano_financeiro,
     null                                   as cd_historico_financeiro,
     1                                      as cd_moeda,
     @cd_usuario                            as cd_usuario,
     getdate()                              as dt_usuario,
     null                                   as cd_lancamento_padrao,
     null                                   as cd_conta,
     null                                   as cd_conta_debito,
     null                                   as cd_conta_credito,
     null                                   as dt_contabilizacao,
     null                                   as cd_lancamento_contabil,
     null                                   as cd_lote,
     null                                   as cd_documento,
     null                                   as cd_documento_baixa,
     'N'                                    as ic_lancamento_conciliado,
     2                                      as cd_tipo_lancamento_fluxo,
    null as vl_cotacao_moeda,
    null as dt_cotacao_moeda,
    null as cd_requisicao_viagem,
    null as cd_solicitacao,
    null as cd_prestacao,
    null as cd_ap,
    null as vl_caixa_moeda,
    null as nm_obs_caixa_lancamento


  into
    #caixa_lancamento

  insert into 
    caixa_lancamento
  select
    *
  from
    #caixa_lancamento

  drop table #caixa_lancamento 

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_caixa, 'D'

  update
    fornecedor_adiantamento
  set
    cd_lancamento_caixa     = @cd_lancamento_caixa
  where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor

  end

end

-----------------------------------------------------------------------------------------
--Exclusão Total do Adiantamento de Fornecedor
-----------------------------------------------------------------------------------------

if @ic_parametro = 2

begin

  select
    @cd_lancamento       = cd_lancamento,
    @cd_lancamento_caixa = cd_lancamento_caixa,
    @cd_ap               = cd_ap
  from
    fornecedor_adiantamento with (nolock) 
  where
    cd_fornecedor           = @cd_fornecedor and
    cd_item_adto_fornecedor = @cd_item_adto_fornecedor
    
  delete from conta_banco_lancamento       where cd_lancamento       = @cd_lancamento
  delete from caixa_lancamento             where cd_lancamento_caixa = @cd_lancamento_caixa  
  delete from autorizacao_pagto_composicao where cd_ap               = @cd_ap
  delete from autorizacao_pagamento        where cd_ap               = @cd_ap
  

end


