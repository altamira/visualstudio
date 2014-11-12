
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2007
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Geração de Autorização de Pagamento para Prestação de Contas
--Data           : 25.04.2006
--Atualizado     : 25.04.2006
--               : 01.05.2007
--               : 17.05.2007
--               : 23.05.2007
--               : 27.05.2007 - Geração do Contas a Pagar
--               : 26.10.2007 - Exclusão da Ap - Carlos Fernandes
--               : 28.10.2007 - Acertos/Moeda - Carlos Fernandes
--               : 05.11.2007 - Novos Atributos - Carlos Fernandes
-- 26.12.2007 - Novo flag de Previsão do Documento Pagar - Carlos Fernandes
-- 04.12.2008 - Pedido de Importação - Carlos Fernandes
-- 27.02.2009 - Novos campos da tabela de documento_pagar - Carlos Fernandes
-- 31.05.2010 - Tipo de Destinatário - Carlos Fernandes
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_geracao_ap_prestacao_conta
@ic_parametro            int      = 0,
@cd_prestacao            int      = 0,
@cd_usuario              int      = 0,
@dt_emissao              datetime = ''
as

begin

--select * from prestacao_conta
--select * from tipo_autorizacao_pagamento

  declare @Tabela		     varchar(50)

  --Geração da Autorização de Pagamento

  declare @cd_ap                     int
  declare @cd_item_ap                int 
  declare @vl_ap                     float
  declare @ds_ap                     varchar(8000)
  declare @cd_funcionario            int
  declare @cd_requisicao_viagem      int
  declare @cd_solicitacao            int
  declare @cd_centro_custo           int
  declare @cd_tipo_ap                int
  declare @dt_ap                     datetime
  declare @cd_moeda                  int

  set @cd_tipo_ap = 9
--set @dt_ap      = cast(convert(varchar(10),getdate(),103) as datetime) --dbo.fn_data( getdate() )

  if @dt_emissao is null 
     set @dt_ap      = cast(convert(int,getdate(),103) as datetime)
  else
     set @dt_ap = @dt_emissao

  --Deleta a Autorização de Pagamento

  select
    @cd_ap = isnull(cd_ap,0)
  from
    Prestacao_Conta with (nolock) 
  where
    cd_prestacao = @cd_prestacao

  if @cd_ap > 0
  begin
    update 
      prestacao_conta
    set
      cd_ap = 0
    where
      cd_prestacao = @cd_prestacao

    delete from autorizacao_pagamento_contabil where cd_ap = @cd_ap    
    delete from autorizacao_pagto_composicao   where cd_ap = @cd_ap
    delete from autorizacao_pagamento          where cd_ap = @cd_ap
    delete from documento_pagar                where cd_ap = @cd_ap

  end

-----------------------------------------------------------------------------------------
--Geração da Autorização de Pagamento
-----------------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Autorizacao_Pagamento' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
	
  while exists(Select top 1 'x' from autorizacao_pagamento where cd_ap = @cd_ap)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'
  end
 
  --select * from prestacao_conta
 
  select 
    @vl_ap                 = isnull(vl_prestacao,0) * case when isnull(vl_prestacao,0)<0 then -1 else 1 end ,
    @ds_ap                 = 'Prestação de Contas No.: '+cast(cd_prestacao as varchar),
    @cd_funcionario        = cd_funcionario,
    @cd_requisicao_viagem  = cd_requisicao_viagem,
    @cd_solicitacao        = cd_solicitacao_adiantamento,
    @cd_centro_custo       = cd_centro_custo,
    @cd_moeda              = cd_moeda  

  from
    prestacao_conta with (nolock) 
  where
    cd_prestacao = @cd_prestacao
    and isnull(cd_ap,0) = 0

   --Atualização Prestação de Contas
     
    update
      prestacao_conta
    set
      cd_ap = @cd_ap
    where
      cd_prestacao = @cd_prestacao

------------------------------------------------------------------------------
--Geração da AP
------------------------------------------------------------------------------
--select * from tipo_autorizacao_pagamento

  select
    @cd_ap                   as cd_ap,
    @dt_ap                   as dt_ap,
    @ds_ap                   as ds_ap,
    null                     as dt_aprovacao_ap,
    @vl_ap                   as vl_ap,
    @cd_usuario              as cd_usuario,
    getdate()                as dt_usuario,
    null                     as cd_usuario_aprovacao,
    @cd_tipo_ap              as cd_tipo_ap,
    null                     as cd_cheque_pagar,
    @cd_requisicao_viagem    as cd_requisicao_viagem,
    @cd_solicitacao          as cd_solicitacao,
    @cd_funcionario          as cd_funcionario,
    null                     as cd_fornecedor,
    null                     as cd_documento_pagar,
    @cd_prestacao            as cd_prestacao,
    null                     as cd_item_adto_fornecedor,
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
     @cd_ap                                 as cd_ap,
     cd_prestacao                           as cd_item_ap,
     null                                   as cd_tipo_documento,
     cd_prestacao                           as cd_documento_ap,
     @cd_usuario                            as cd_usuario,
     getdate()                              as dt_usuario,
     'A'                                    as ic_tipo_documento_ap,
     'PC-'+cast(cd_prestacao as varchar)    as cd_identificacao_documento
   into
     #autorizacao_pagto_composicao
   from
     Prestacao_Conta
   where
     cd_prestacao = @cd_prestacao

   --select * from #autorizacao_pagto_composicao
 
   insert into
     autorizacao_pagto_composicao 
   select
     *
   from
     #autorizacao_pagto_composicao

   exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'


   -----------------------------------------------------------------------------------------
   --Geração do Contas a Pagar
   -----------------------------------------------------------------------------------------
   --select * from documento_pagar

  declare @cd_documento_pagar        int
  declare @cd_tipo_documento         int
  declare @cd_plano_financeiro       int
  declare @cd_situacao_documento     int
  declare @cd_tipo_conta_pagar       int
  declare @cd_portador               int
  declare @cd_identificacao_document varchar(30)

  set @cd_identificacao_document = 'PC-'+cast(@cd_prestacao as varchar)

  --Verifica se existe o Documento

  if not exists(select top 1 cd_identificacao_document from documento_pagar 
                where 
                  cd_identificacao_document = @cd_identificacao_document ) and @vl_ap>0

  begin


     --Busca os Parâmetros
     select
       @cd_tipo_documento     = isnull(cd_tipo_documento,0),
       @cd_plano_financeiro   = isnull(cd_plano_financeiro,0),
       @cd_centro_custo       = case when isnull(@cd_centro_custo,0)=0 then isnull(cd_centro_custo,0) else @cd_centro_custo end,
       @cd_situacao_documento = isnull(cd_situacao_documento,0),
       @cd_tipo_conta_pagar   = isnull(cd_tipo_conta_pagar,0),
       @cd_portador           = isnull(cd_portador,0)
     from
       Config_Geracao_Documento_pagar
     where
      cd_empresa = dbo.fn_empresa() and
      cd_tipo_ap = @cd_tipo_ap

     -- Nome da Tabela usada na geração e liberação de códigos
     set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

     exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output
	
     while exists(Select top 1 'x' from documento_pagar where cd_documento_pagar = @cd_documento_pagar)
     begin
       exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output

       -- limpeza da tabela de código
       exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'
     end

    select
      @cd_documento_pagar                          as cd_documento_pagar,
      'PC-'+cast(@cd_prestacao as varchar)         as cd_identificacao_document,
      @dt_ap                                       as dt_emissao_documento_paga,
      @dt_ap                                       as dt_vencimento_documento,
      @vl_ap                                       as vl_documento_pagar,
      null                                         as dt_cancelamento_documento,
      null                                         as nm_cancelamento_documento,
      null                                         as cd_nota_fiscal_entrada,
      null                                         as cd_serie_nota_fiscal_entr,
      null                                         as nm_numero_bancario,
      null                                         as nm_observacao_documento,
      @vl_ap                                       as vl_saldo_documento_pagar,
      null                                         as dt_contabil_documento_pag,
      null                                         as cd_empresa_diversa,
      null                                         as cd_favorecido_empresa,
      dbo.fn_empresa()                             as cd_empresa,
      @cd_funcionario                              as cd_funcionario,
      null                                         as cd_contrato_pagar,
      @cd_tipo_documento                           as cd_tipo_documento,
      @cd_tipo_conta_pagar                         as cd_tipo_conta_pagar,
      null                                         as cd_fornecedor,
      @cd_usuario                                  as cd_usuario,
      getdate()                                    as dt_usuario,
      null                                         as cd_identificacao_sap,
      null                                         as cd_pedido_compra,
      @cd_plano_financeiro                         as cd_plano_financeiro,
      null                                         as vl_juros_documento,
      null                                         as vl_abatimento_documento,
      null                                         as vl_desconto_documento,
      null                                         as nm_fantasia_fornecedor,
      null                                         as cd_tipo_pagamento,
      null                                         as dt_fluxo_docto_pagar,
      null                                         as ic_fluxo_caixa,
      null                                         as cd_cheque_pagar,
      null                                         as cd_nota_saida,
      null                                         as nm_motivo_dev_documento,
      null                                         as dt_devolucao_documento,
      @cd_portador                                 as cd_portador,
      null                                         as dt_envio_banco_documento,
      null                                         as dt_retorno_banco_doc,
      'N'                                          as ic_envio_documento,
      null                                         as cd_arquivo_magnetico,
      null                                         as cd_serie_nota_fiscal,
      null                                         as cd_numero_banco_documento,
      null                                         as cd_receita_darf,
      null                                         as cd_competencia_gps,
      null                                         as cd_tipo_pagto_eletronico,
      null                                         as cd_forma_pagto_eletronica,
      null                                         as cd_imposto,
      case when isnull(@cd_moeda,0)>0 
      then @cd_moeda else 1 end                    as cd_moeda,
      null                                         as cd_embarque_chave,
      null                                         as dt_selecao_documento,
      null                                         as cd_loja,
      null                                         as vl_documento_pagar_moeda,
      null                                         as cd_invoice,
      null                                         as pc_imposto_documento,
      null                                         as cd_fechamento_cambio,
      null                                         as vl_tarifa_contrato_cambio,
      null                                         as vl_saldo_anterior_fecha_cambio,
      null                                         as ic_deposito_documento,
      null                                         as ic_tipo_deposito,
      @cd_centro_custo                             as cd_centro_custo,
      null                                         as vl_multa_documento,
      null                                         as cd_darf_automatico,
      null                                         as selecao,
      null                                         as nm_selecao,
      null                                         as cd_selecao,
      null                                         as dt_envio_banco,
      null                                         as cd_tipo_movimento,
      null                                         as cd_conta_banco_pagamento,
      null                                         as dt_pagamento_documento,
      null                                         as vl_pagamento_documento,
      @cd_situacao_documento                       as cd_situacao_documento,
      null                                         as cd_cheque_terceiro,
      @cd_ap                                       as cd_ap,
      null                                         as ic_sel_ap,
      null                                         as dt_vencimento_original,
      'N'                                          as ic_previsao_documento,
      null                                         as nm_complemento_documento,
      null                                         as cd_pedido_importacao,
      null                                         as cd_tipo_fluxo_caixa,
      cast(dbo.fn_strzero(datepart(mm,@dt_ap),2)   as varchar(02))+'/'+
      cast(datepart(yyyy,@dt_ap) as varchar(04))   as nm_ref_documento_pagar,
      null                                         as cd_tipo_destinatario      


--select * from documento_pagar
    into
      #documento_pagar

    insert into
      documento_pagar
    select
      *
    from
      #documento_pagar

    drop table #documento_pagar

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'

   end

  end

end

