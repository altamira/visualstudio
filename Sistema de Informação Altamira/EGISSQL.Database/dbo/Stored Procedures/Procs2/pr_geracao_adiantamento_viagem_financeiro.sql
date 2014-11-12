
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2007
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Geração do Adiantamento de Viagem para o financeiro
--Data           : 25.04.2006
--Atualizado     : 25.04.2006
--               : 01.05.2007
--               : 17.05.2007
--               : 23.05.2007
--               : 26.06.2007 - Geração do Contas a Pagar
--               : 04.06.2007 - Tipo de Adiantamento - Carlos Fernandes
--               : 06.06.2007 - Revisão - Carlos Fernandes
--               : 24.08.2007 - Acertos Diversos - Carlos Fernandes
--               : 31.08.2007 - Gravação do documento na AP - Carlos Fernandes.
--               : 05.11.2007 - Complemento dos novos atributos - Carlos Fernandes
-- 25.11.2007    : Novo campo de assunto de viagem - Carlos Fernandes
-- 30.11.2007    : Novo campo para identificar o e-mail para aprovação - Carlos Fernandes
-- 19.12.2007    : Novo campo na tabela de documento_pagar - Carlos Fernandes
-- 18.01.2008    : Novo Atributo para Solicitação em Outra Moeda - Carlos Fernandes
-- 15.02.2008    : Novo Atributo para Gravação dos comentários de Aprovação/Reprovação - Carlos Fernandes
-- 18.02.2008    : Novo Atribugo para Data da Liberação para Aprovação - Carlos Fernandes
-- 18.03.2008    : Verificação da Geração de Moeda Estrangeira - Carlos Fernandes
-- 20.03.2008    : Adiantamento de Valor de Cartão de crédito - Carlos Fernandes
-- 28.03.2008    : Novos flags no Tipo de Adiantamento para Geração Solicitação Adto/AP - Carlos Fernandes
-- 04.04.2008    : Viagem Internacional - Carlos Fernandes
-- 28.04.2008    : Novo Atributo com o código do funcionário da Liberação    - Carlos Fernandes
-- 06.05.2008    : Ajuste da Data do Vencimento conforme data da Necessidade - Carlos Fernandes
-- 12.05.2008    : Exclusão de Adiantamento - ok.
-- 26.05.2008    : Inclusão de um novo Campo - Carlos Fernandes - ok.
-- 04.12.2008    : Pedido de Importaçõ - Carlos Fernandes - ok.
-- 20.02.2009    : Novo campo na tabela de contas a pagar - ok.
-- 31.05.2010    : Novo campo na tabela de contas a pagar - Tipo de Destinatário - Carlos Fernandes
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_geracao_adiantamento_viagem_financeiro
@cd_requisicao_viagem    int      = 0,
@cd_usuario              int      = 0,
@ic_geracao_ap           char(1)  = 'S' --Geração de Autorização de Pagamento

--@dt_ap                   datetime = ''

as


--Verifica se existe a Requisição de Viagem

-- if isnull(@cd_requisicao_viagem,0) = 0
-- begin
--   exit
-- end

--select * from tipo_adiantamento
--select * from solicitacao_adiantamento
--select * from requisicao_viagem
--select * from parametro_financeiro
--select * from documento_pagar

  declare @ic_gera_adiantamento char(1)
  declare @ic_gera_ap           char(1)
  declare @ic_gera_contas_pagar char(1)
  declare @Tabela		     varchar(80)
  declare @cd_solicitacao            int
  declare @qt_dia_acerto_adto        int
  declare @cd_funcionario            int 
  declare @cd_ap                     int
  declare @cd_item_ap                int 
  declare @vl_ap                     float
  declare @ds_ap                     varchar(8000)
  declare @cd_moeda                  int
  declare @cd_tipo_ap                int 
  declare @cd_centro_custo           int
  declare @dt_ap                     smalldatetime
  declare @ic_gera_caixa             char(1)
  declare @cd_tipo_adiantamento      int
  declare @dt_vencimento_documento   smalldatetime


  --Verifica o que deve ser gerado conforme o tipo de Adiantamento

  --verifica se gera Adiantamento

  --verifica se gera Autorização de Pagamento

  set @cd_ap = 0
  set @dt_ap = cast(convert(varchar(10),getdate(),103) as datetime) --dbo.fn_data( getdate() ) --getdate() 
  set @dt_vencimento_documento = @dt_ap
  --Dados da Requisicao_Viagem
    
  select
    @ic_gera_adiantamento    = isnull(ta.ic_gera_adiantamento,'S'),
    @ic_gera_ap              = isnull(ta.ic_gera_ap,'S'),
    @ic_gera_contas_pagar    = isnull(ta.ic_gera_contas_pagar,'S'),
    @dt_vencimento_documento = case when rv.dt_necessidade_viagem is not null and rv.dt_necessidade_viagem>dt_requisicao_viagem and rv.dt_necessidade_viagem>@dt_ap
                               then
                                 rv.dt_necessidade_viagem
                               else
                                 @dt_ap
                               end
  from
    requisicao_viagem rv            with (nolock) 
    inner join tipo_adiantamento ta with (nolock) on ta.cd_tipo_adiantamento = rv.cd_tipo_adiantamento
  where
    rv.cd_requisicao_viagem = @cd_requisicao_viagem

  --Busca a quantidade de dias para acerto do Adiantamnto de Viagem

  select  
    @qt_dia_acerto_adto = isnull(qt_dia_acerto_adto,0)
  from
    parametro_financeiro
  where
    cd_empresa = dbo.fn_empresa()

  --Deleta a Requisição de Viagem na Tabela de Adiantamentos

  delete from solicitacao_adiantamento where cd_requisicao_viagem = @cd_requisicao_viagem

  --   set @cd_ap = 0
  --   set @dt_ap = cast(convert(varchar(10),getdate(),103) as datetime) --dbo.fn_data( getdate() ) --getdate() 
  --   select @dt_ap

-----------------------------------------------------------------------------------------
--Geração da Autorização de Pagamento
-----------------------------------------------------------------------------------------

if @ic_gera_ap = 'S' AND @ic_geracao_ap = 'S' 

begin

  --select * from requisicao_viagem

  set @cd_tipo_ap = 4 --Adiantamento de Viagem

  --Deleta a Autorização de Pagamento

  select
    @cd_ap = isnull(cd_ap,0)
  from
    Autorizacao_Pagamento with (nolock) 
  where
    cd_requisicao_viagem = @cd_requisicao_viagem

  if @cd_ap > 0
  begin

    update 
      requisicao_viagem
    set
      cd_ap = 0
    where
      cd_requisicao_viagem = @cd_requisicao_viagem
    
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
    @vl_ap                = isnull(vl_adto_viagem,0),
    @ds_ap                = 'RV : '+cast(cd_requisicao_viagem as varchar),
    @cd_funcionario       = cd_funcionario,
    @cd_moeda             = cd_moeda,
    @cd_centro_custo      = cd_centro_custo,
    @cd_tipo_adiantamento = isnull(cd_tipo_adiantamento,0)
  from
    requisicao_viagem with (nolock) 
  where
    cd_requisicao_viagem = @cd_requisicao_viagem and
    isnull(cd_ap,0) = 0

------------------------------------------------------------------------------
--Geração da AP
------------------------------------------------------------------------------
--select * from tipo_autorizacao_pagamento
--select * from autorizacao_pagamento

  select
    @cd_ap                   as cd_ap,
    @dt_ap                   as dt_ap,
    @ds_ap                   as ds_ap,
    null                     as dt_aprovacao_ap,
    @vl_ap                   as vl_ap,
    @cd_usuario              as cd_usuario,
    getdate()                as dt_usuario,
    null                     as cd_usuario_aprovacao,
    4                        as cd_tipo_ap,
    null                     as cd_cheque_pagar,
    @cd_requisicao_viagem    as cd_requisicao_viagem,
    null                     as cd_solicitacao,
    @cd_funcionario          as cd_funcionario,
    null                     as cd_fornecedor,
    null                     as cd_documento_pagar,
    null                     as cd_prestacao,
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
     @cd_ap                                        as cd_ap,
     @cd_requisicao_viagem                         as cd_item_ap,
     null                                          as cd_tipo_documento,
     @cd_requisicao_viagem                         as cd_documento_ap,
     @cd_usuario                                   as cd_usuario,
     getdate()                                     as dt_usuario,
     'A'                                           as ic_tipo_documento_ap,
     'RV : '+cast(cd_requisicao_viagem as varchar) as cd_identificacao_documento
   into
     #autorizacao_pagto_composicao
   from
     requisicao_viagem
   where
     cd_requisicao_viagem = @cd_requisicao_viagem

  --select * from autorizacao_pagamento
  --select * from #autorizacao_pagto_composicao
 
  insert into
    autorizacao_pagto_composicao 
  select
    *
  from
    #autorizacao_pagto_composicao

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'

  -----------------------------------------------------------------------------------------
  --Atualização da Requisição de Viagem
  -----------------------------------------------------------------------------------------
     
   update
     requisicao_viagem
   set
     cd_ap = @cd_ap
   where
    cd_requisicao_viagem = @cd_requisicao_viagem

end


-----------------------------------------------------------------------------------------
--Geração do Adiantamento
-----------------------------------------------------------------------------------------
--print 'adiantamento'

if @ic_gera_adiantamento = 'S'
begin

  if not exists( select top 1 cd_requisicao_viagem from solicitacao_Adiantamento where cd_requisicao_viagem = @cd_requisicao_viagem ) 
  begin

    set @cd_solicitacao = 0

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Solicitacao_Adiantamento' as varchar(50))

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_solicitacao', @codigo = @cd_solicitacao output
	
    while exists(Select top 1 'x' from solicitacao_adiantamento where cd_solicitacao = @cd_solicitacao)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_solicitacao', @codigo = @cd_solicitacao output

      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_solicitacao, 'D'
    end

    --select * from finalidade_adiantamento

    select
      @cd_solicitacao                      as cd_solicitacao,
      --@dt_ap                             as dt_solicitacao,
      dt_requisicao_viagem                 as dt_solicitacao,
      dt_necessidade_viagem                as dt_necessidade,
      cd_funcionario,
      cd_centro_custo,
      cd_departamento,
      isnull(( select top 1 cd_finalidade_adiantamento 
          from
           Finalidade_Adiantamento
          where 
            isnull(ic_tipo_finalidade,'D') = 'R' or
            isnull(ic_pad_finalidade_adiantamento,'N') = 'S'),0)
                                           as cd_finalidade_adiantamento,
      cd_requisicao_viagem,
      ds_requisicao_viagem                 as ds_solicitacao,
      getdate() + @qt_dia_acerto_adto      as dt_vencimento,
      cd_moeda,
      vl_adto_viagem                       as vl_adiantamento,
      vl_adto_viagem                       as vl_saldo_adiantamento,
      @cd_usuario                          as cd_usuario,
      getdate()                            as dt_usuario,
      null                                 as dt_liberacao_adiantamento,
      null                                 as cd_usuario_liberacao,
      dt_moeda_requisicao                  as dt_moeda_solicitacao,
      vl_cotacao_requisicao                as vl_cotacao_solicitacao,
      vl_total_moeda_requisicao            as vl_total_moeda_solicitacao,
      null                                 as cd_prestacao,
      2                                    as ic_tipo_adiantamento,
      @cd_ap                               as cd_ap,
      cd_tipo_adiantamento                 as cd_tipo_adiantamento,
      null                                 as dt_pagamento_solicitacao,
      null                                 as dt_contabilizacao_solicitacao,
      null                                 as cd_conta,
      null                                 as dt_conf_solicitacao,
      rv.cd_projeto_viagem                 as cd_projeto_viagem,
      'N'                                  as ic_sel_deposito_adiantamento,
      rv.cd_assunto_viagem                 as cd_assunto_viagem,
      rv.cd_usuario_aprovacao              as cd_usuario_aprovacao,
      rv.cd_funcionario_aprovacao          as cd_funcionario_aprovacao,
      rv.ic_email_requisicao               as ic_email_solicitacao,
      null                                 as dt_financeiro_solicitacao,
      @cd_usuario                          as cd_usuario_requisicao,
      rv.vl_adto_moeda                     as vl_solicitacao_moeda,
      rv.ds_temp_obs_aprovacao             as ds_temp_obs_aprovacao,
      null                                 as dt_liberacao_aprovacao,
      rv.cd_secretaria                     as cd_secretaria,
      null                                 as dt_aviso_cobranca,
      null                                 as cd_cartao_credito,
      null                                 as dt_lib_viagem_internacional,
      getdate()                            as dt_prevista_aprovacao,
      null                                 as dt_reenvio_aprovacao,
      rv.cd_funcionario_liberacao          as cd_funcionario_liberacao,
      null                                 as cd_documento_pagar

--select * from solicitacao_adiantamento

    into
      #Solicitacao_Adiantamento

    from 
      Requisicao_Viagem rv with (nolock)

    where
      cd_requisicao_viagem = @cd_requisicao_viagem  

--   print 'aqui'


--select * from #Solicitacao_Adiantamento
--select * from Solicitacao_Adiantamento

--    print 'gravei adto'

    insert into Solicitacao_Adiantamento
    select
      *
    from
      #Solicitacao_Adiantamento

    --Geração da Contabilização do Adiantamento
    --print 'gera contab adto'

    exec pr_gera_contabilizacao_adiantamento 1,@cd_solicitacao,@cd_usuario

    
    --Liberação do Código

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_solicitacao, 'D'

  end

end
 
-----------------------------------------------------------------------------------------
--Geração do Contas a Pagar
-----------------------------------------------------------------------------------------
  --select * from documento_pagar

--    print 'geracao scp'

if @ic_gera_contas_pagar = 'S'
begin

  declare @cd_documento_pagar        int
  declare @cd_tipo_documento         int
  declare @cd_plano_financeiro       int
  declare @cd_situacao_documento     int
  declare @cd_tipo_conta_pagar       int
  declare @cd_portador               int
  declare @cd_identificacao_document varchar(30)

  set @cd_identificacao_document = 'RV-'+cast(@cd_requisicao_viagem as varchar)

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
      'RV-'+cast(@cd_requisicao_viagem as varchar) as cd_identificacao_document,
      @dt_ap                                       as dt_emissao_documento_paga,
      --@dt_ap                                       as dt_vencimento_documento,
      @dt_vencimento_documento                     as dt_vencimento_documento,
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
      @cd_moeda                                    as cd_moeda,
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
      null                                         as cd_ap,
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


--    print 'até aqui ok'

    insert into
      documento_pagar
    select
      *
    from
      #documento_pagar

    drop table #documento_pagar

    --Atualiza a Requisição de Viagem com o Documento a Pagar

    update
      requisicao_viagem
    set
      cd_documento_pagar = @cd_documento_pagar
    from
      requisicao_viagem 
    where
      cd_requisicao_viagem = @cd_requisicao_viagem

    --Solicitação de Adto.----------------------------------------------

    update
      solicitacao_adiantamento
    set
      cd_documento_pagar   = @cd_documento_pagar
    where
      cd_solicitacao       = @cd_solicitacao

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'

  end

end

-----------------------------------------------------------------------------------------
--Geração do Lançamento de Caixa
-----------------------------------------------------------------------------------------

if @cd_tipo_adiantamento>0
begin

  select 
    @ic_gera_caixa = isnull(ic_gera_caixa,'N')
  from
    tipo_adiantamento with (nolock) 
  where
    cd_tipo_adiantamento = @cd_tipo_adiantamento

  if @ic_gera_caixa='S'
  begin   

    --Busca o Tipo de Caixa conforma a Moeda

    declare @cd_tipo_caixa int
   
    select
      @cd_tipo_caixa = isnull(cd_tipo_caixa,0)
    from
      Moeda with (nolock) 
    where
      cd_moeda = @cd_moeda

    if @cd_tipo_caixa>0 
    begin

      exec pr_gera_movimento_caixa
        @cd_tipo_caixa,
        @cd_usuario,
        1,
        @cd_requisicao_viagem

    end

  end

end  

