
create procedure pr_gerar_doctos_pagar_retencao
------------------------------------------------------------------------
--GBS - Global Business Solution	             2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)	     : Eduardo Baião
--Banco de Dados : EGISSQL
--Objetivo       : Gerar os Documentos à Pagar dos Impostos retidos
--                 da Nota Fiscal de Entrada.
--Data           : 22/07/2003 
--Alteração      : 13/07/2005 - Diversas Modificações - ELIAS
--               : 05/08/2005 - Incluído suporte para gerar registros somente para apresentação
--                              na DIRF - ELIAS
--               : 17/08/2005 - Incluído Rotina para Gravação do Contas a Pagar de uma Retenção de
--                              Pagamento - ELIAS
-- 04.05.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------
@ic_parametro         int,
@cd_nota_entrada      int, 
@cd_fornecedor        int, 
@cd_operacao_fiscal   int,
@cd_serie_nota_fiscal int,
@cd_usuario           int,
@cd_documento_pagar   int,
@ic_gerar_conta_pagar char(1) = 'S',
@ic_gerar_dirf        char(1) = 'N',
@ic_imposto           char(1) = 'N'

as

  -- variáveis locais
  declare @dt_imposto_scp_automatico datetime,
          @cd_empresa                int,
          @sg_serie_nota_fiscal      varchar(5),
          @dt_nota_entrada           datetime,
          @dt_receb_nota_entrada     datetime,
          @nm_fantasia_fornecedor    varchar(30),
          @cd_identificacao          varchar(80),
          @dt_vencimento             datetime,
          @dt_competencia            datetime,
          @dt_inicio_competencia     datetime, 
          @dt_fato_gerador           datetime,
          @nm_observacao             varchar(40),
          @cd_imposto                int,
          @sg_imposto                char(10),
          @cd_imposto_especificacao  int,
          @cd_receita_tributo        int,
          @cd_darf_codigo            int,
          @cd_empresa_diversa        int,
          @cd_favorecido_empresa     int,
          @cd_tipo_documento         int,
          @cd_plano_financeiro       int,
          @cd_tipo_conta_pagar       int,
          @cd_item_retencao_imposto  int,
          @Tabela                    varchar(50),
          @vl_pis_cofins_csll        decimal(25,2),
          @vl_irrf decimal(25,2),
          @vl_inss decimal(25,2),
          @vl_iss decimal(25,2),
          @vl_total_parcela decimal(25,2),
          @vl_tributado_imposto decimal(25,2),
          @vl_imposto decimal(25,2),
          @cd_chave int,
          @cd_moeda int,
          @cd_identificacao_parcela varchar(30),
          @ic_reter_iss char(1),
          @cd_doc_pagar int

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Geração Automática do Contas a Pagar através de NFE
-------------------------------------------------------------------------------
begin

  SET NOCOUNT ON 

  select @cd_moeda = isnull(cd_moeda,1) 
  from parametro_financeiro with (nolock) 
  where cd_empresa = dbo.fn_empresa()

  -------------------------------------------------------------
  -- Consiste a Parcela da NF com o Documento a Pagar
  -------------------------------------------------------------
  /*
  update nota_entrada_parcela set cd_documento_pagar = dp.cd_documento_pagar
  from nota_entrada_parcela nep left outer join 
       documento_pagar dp on nep.cd_fornecedor = dp.cd_fornecedor and
       cast(nep.cd_ident_parc_nota_entr as varchar(30)) = dp.cd_identificacao_document and
       nep.cd_serie_nota_fiscal = dp.cd_serie_nota_fiscal
  where isnull(nep.cd_documento_pagar,0) <> dp.cd_documento_pagar and
        nep.cd_nota_entrada = @cd_nota_entrada and
        nep.cd_fornecedor = @cd_fornecedor and
        nep.cd_operacao_fiscal = @cd_operacao_fiscal and
        nep.cd_serie_nota_fiscal = @cd_serie_nota_fiscal
  */
  -------------------------------------------------------------
  -- Pegar os dados da Nota Fiscal de Entrada
  -------------------------------------------------------------

  select top 1 
    @sg_serie_nota_fiscal  = s.sg_serie_nota_fiscal,
    @dt_nota_entrada       = dt_nota_entrada,
    @dt_receb_nota_entrada = dt_receb_nota_entrada,
    @vl_pis_cofins_csll    = isnull(vl_pis_nota_entrada,0)+
                             isnull(vl_cofins_nota_entrada,0)+
                             isnull(vl_csll_nota_entrada,0),
    @vl_irrf               = isnull(vl_irrf_nota_entrada,0),
    @vl_inss               = isnull(vl_inss_nota_entrada,0),
    @vl_iss                = isnull(vl_iss_nota_entrada,0),
    @ic_reter_iss          = isnull(ic_reter_iss,'N'),
    @vl_tributado_imposto  = isnull(vl_total_nota_entrada,0)
  from Nota_Entrada n with (nolock) 
    left outer join Serie_Nota_Fiscal s on s.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal
  where 
    n.cd_nota_entrada      = @cd_nota_entrada and
    n.cd_fornecedor        = @cd_fornecedor and
    n.cd_operacao_fiscal   = @cd_operacao_fiscal and
    n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal

  -- Pegar a Empresa Atual
  set @cd_empresa = dbo.fn_empresa()

  -- Puxar a Data de início de Vigência da Retenção Automática dos Impostos
  select @dt_imposto_scp_automatico = dt_imposto_scp_automatico
  from Parametro_Logistica with (nolock) 
  where cd_empresa = @cd_empresa 

  --if (@dt_imposto_scp_automatico is null) or
  --  (@dt_receb_nota_entrada < @dt_imposto_scp_automatico)
  --  return

  ----------------------------------------------------------------------
  -- Tabela temporária com as informações das Retenções já geradas para
  -- verificar se será possível excluir os registros de impostos
  ----------------------------------------------------------------------
  select neri.cd_nota_entrada, neri.cd_fornecedor, neri.cd_operacao_fiscal,
    neri.cd_serie_nota_fiscal, neri.cd_documento_pagar,
    dp.cd_imposto
  into #Nota_Entrada_Retencao_Imposto
  from Nota_Entrada_Retencao_Imposto neri 
    left outer join Documento_Pagar dp on dp.cd_documento_pagar = neri.cd_documento_pagar
  where
    neri.cd_nota_entrada      = @cd_nota_entrada and
    neri.cd_fornecedor        = @cd_fornecedor and
    neri.cd_operacao_fiscal   = @cd_operacao_fiscal and
    neri.cd_serie_nota_fiscal = @cd_serie_nota_fiscal

  -- verifica se as duplicatas geradas anteriormente já foram pagas
  if exists (select top 1 'x'
             from documento_pagar_pagamento with (nolock) 
             where cd_documento_pagar in (select cd_documento_pagar from #Nota_Entrada_Retencao_Imposto))
    raiserror('Já foi efetuado pagamento de um ou mais Impostos gerados anteriormente! Não foi será possível gerar os Impostos novamente.', 16,1)

  -----------------------------------------------------------------
  -- Apaga as Tabelas de Documento_Pagar, Documento_Pagar_Imposto e 
  -- Nota_Entrada_Retencao
  -----------------------------------------------------------------

  -- apaga os registro de Impostos Retidos
  delete from Nota_Entrada_Retencao_Imposto
  from Nota_Entrada_Retencao_Imposto neri inner join 
    #Nota_Entrada_Retencao_Imposto ni on neri.cd_nota_entrada = ni.cd_nota_entrada and
                                         neri.cd_fornecedor = ni.cd_fornecedor and
                                         neri.cd_operacao_fiscal = ni.cd_operacao_fiscal and
                                         neri.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal 

  if (@ic_gerar_conta_pagar = 'S') 
  begin

    -- apaga detalhes das duplicatass
    delete From Documento_Pagar_Imposto 
    where cd_documento_pagar in 
      (select cd_documento_pagar
       from #Nota_Entrada_Retencao_Imposto)

    -- apaga as duplicatas
    delete From Documento_Pagar 
    where cd_documento_pagar in 
      (select cd_documento_pagar
       from #Nota_Entrada_Retencao_Imposto)

  end

  ----------------------------------------------------------------------------
  -- Carregar a tabela com as configurações dos impostos que devem ser Gerados
  ----------------------------------------------------------------------------
  select idp.cd_imposto, i.sg_imposto, i.qt_dia_pagto_imposto, i.ic_tipo_pagamento_imposto,
    i.cd_imposto_especificacao, i.cd_receita_tributo, i.cd_darf_codigo, idp.cd_empresa_diversa,
    idp.cd_favorecido_empresa, idp.cd_tipo_documento, idp.cd_tipo_conta_pagar, idp.cd_plano_financeiro
  into #Imposto
  from Imposto_Documento_Pagar idp inner join 
    Imposto i on i.cd_imposto = idp.cd_imposto    

  -------------------------------------------------------------
  -- Alimentar as Tabelas Envolvidas:
  -- Documento_Pagar
  -- Documento_Pagar_Imposto
  -- Nota_Entrada_Retencao_Imposto
  -------------------------------------------------------------
  
  -- Monta Observação
  set @nm_observacao = rtrim(@sg_imposto) + ' - Ref. NFE ' +
    cast(@cd_nota_entrada as varchar) + ' de ' +
    cast( datepart( day, @dt_receb_nota_entrada ) as varchar ) + '/' +
    cast( datepart( month, @dt_receb_nota_entrada ) as varchar ) + '/' +
    cast( datepart( year, @dt_receb_nota_entrada ) as varchar )

  -- Nome Fantasia do Fornecedor
  select @nm_fantasia_fornecedor = nm_fantasia_fornecedor
  from Fornecedor
  where cd_fornecedor = @cd_fornecedor

  set @cd_item_retencao_imposto = 0

  -- IRRF - Alimentar Todas
  if ((isnull(@vl_irrf,0) > 0) or ((@ic_gerar_dirf = 'S') and ((@ic_imposto = 'I') or (@ic_imposto = 'A'))))
  begin

    -- Data do Fato Gerador - EMISSÃO
    set @dt_fato_gerador = @dt_nota_entrada

    -- Calcula o Vencimento e a Competência e Dados para a Gravação do
    -- Contas a Pagar
    select @dt_vencimento = dbo.fn_calcula_vencimento_imposto(
                              @dt_fato_gerador,
                              qt_dia_pagto_imposto,
                              ic_tipo_pagamento_imposto, 'N' ),
           @dt_competencia = dbo.fn_calcula_vencimento_imposto(
                               @dt_fato_gerador,
                               qt_dia_pagto_imposto,
                               ic_tipo_pagamento_imposto, 'S' ),
           @dt_inicio_competencia = dbo.fn_calcula_vencimento_imposto(
                               @dt_fato_gerador,
                               qt_dia_pagto_imposto,
                               ic_tipo_pagamento_imposto, 'I' )
    from #Imposto 
    where cd_imposto = 10 

    set @cd_item_retencao_imposto = 1

    if (@ic_gerar_conta_pagar = 'S') and (@ic_gerar_dirf = 'N')
    begin

      -- Nome da Tabela usada na geração e liberação de códigos
      set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))
  
      -- Pegar a próxima Chave para a Tabela Documento_Pagar
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output
  
      -- Gerar o número de identificação
      exec dbo.pr_novo_documento_diverso 14, @cd_identificacao

      -- Grava o Documento a Pagar  
      insert into Documento_Pagar (cd_documento_pagar, cd_identificacao_document, dt_emissao_documento_paga,
        dt_vencimento_documento, vl_documento_pagar, cd_nota_fiscal_entrada, cd_serie_nota_fiscal_entr,
        nm_observacao_documento, vl_saldo_documento_pagar, cd_tipo_documento, cd_tipo_conta_pagar,
        cd_fornecedor, cd_usuario, dt_usuario, cd_plano_financeiro, nm_fantasia_fornecedor, cd_imposto,
        cd_empresa_diversa, cd_favorecido_empresa)
      values ( @cd_documento_pagar, 'DIV-'+@cd_identificacao, @dt_nota_entrada,
        @dt_vencimento, @vl_irrf, @cd_nota_entrada, cast(@sg_serie_nota_fiscal as char(2)),
        @nm_observacao, @vl_irrf, @cd_tipo_documento, @cd_tipo_conta_pagar, @cd_fornecedor,
        @cd_usuario, getDate(), @cd_plano_financeiro, @nm_fantasia_fornecedor, 10,
        @cd_empresa_diversa, @cd_favorecido_empresa)

      -- Grava os Dados de Imposto do Documento a Pagar  
      insert into Documento_Pagar_Imposto (cd_documento_pagar, cd_imposto, cd_imposto_especificacao,
        cd_receita_tributo, cd_darf_codigo, pc_imposto_documento, nm_observacao_documento, cd_usuario,
        dt_usuario, dt_competencia_apuracao, vl_principal_imposto, vl_multa_imposto, vl_juros_imposto)
      values (@cd_documento_pagar, 10, @cd_imposto_especificacao, @cd_receita_tributo, @cd_darf_codigo,
        null, @nm_observacao, @cd_usuario, getDate(), @dt_competencia, @vl_irrf, 0.00, 0.00)

      -- Limpando tabela de Códigos
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   

    end
       
    -- Gerar os registros de Impostos Retidos na Nota de Entrada
    insert into Nota_Entrada_Retencao_Imposto (cd_nota_entrada, cd_fornecedor, cd_serie_nota_fiscal,
      cd_operacao_fiscal, cd_item_retencao_imposto, cd_documento_pagar, cd_imposto, cd_imposto_especificacao, 
      cd_receita_tributo, cd_darf_codigo, dt_fato_gerador, dt_inicio_apuracao, dt_apuracao_imposto, dt_vencimento_imposto, 
      vl_imposto_retido, cd_usuario, dt_usuario, vl_tributado_imposto)
    select @cd_nota_entrada, @cd_fornecedor, @cd_serie_nota_fiscal, @cd_operacao_fiscal, @cd_item_retencao_imposto,
      @cd_documento_pagar, cd_imposto, cd_imposto_especificacao, cd_receita_tributo, cd_darf_codigo, @dt_fato_gerador, 
      @dt_inicio_competencia, @dt_competencia, @dt_vencimento, @vl_irrf, @cd_usuario, getDate(), @vl_tributado_imposto 
    from #Imposto where cd_imposto = 10     


  end  


  -- PIS/COFINS/CSLL - Alimentar somente a de Nota_Entrada_Retencao_Imposto



  if ((isnull(@vl_pis_cofins_csll,0) > 0) or ((@ic_gerar_dirf = 'S') and ((@ic_imposto = 'C') or (@ic_imposto = 'A'))))
  begin
    ---------------------------------------------------------------------------
    -- CARREGAR DE ACORDO COM OS PAGAMENTOS
    ---------------------------------------------------------------------------
    select @vl_total_parcela = sum(cast(nep.vl_parcela_nota_entrada as decimal(25,2)))
    from Nota_Entrada_Parcela nep
    where nep.cd_nota_entrada = @cd_nota_entrada and
      nep.cd_fornecedor = @cd_fornecedor and
      nep.cd_operacao_fiscal = @cd_operacao_fiscal and
      nep.cd_serie_nota_fiscal = @cd_serie_nota_fiscal

    declare cPagamento cursor for
    select dp.cd_identificacao_document,
           dp.cd_documento_pagar,
           isnull(dpp.dt_pagamento_documento,dp.dt_vencimento_documento),
           cast(((@vl_pis_cofins_csll / @vl_total_parcela) * 
           cast(nep.vl_parcela_nota_entrada as decimal(25,2))) as decimal(25,2)),
           cast(((nep.vl_parcela_nota_entrada / @vl_total_parcela) * 
           cast(ne.vl_total_nota_entrada as decimal(25,2))) as decimal(25,2))
    from Nota_Entrada_Parcela nep inner join 
      Nota_Entrada ne on ne.cd_nota_entrada = nep.cd_nota_entrada and
                         ne.cd_fornecedor = nep.cd_fornecedor and
                         ne.cd_operacao_fiscal = nep.cd_operacao_fiscal and
                         ne.cd_serie_nota_fiscal = nep.cd_serie_nota_fiscal inner join 
      Documento_Pagar dp on nep.cd_documento_pagar = dp.cd_documento_pagar left outer join
      Documento_Pagar_Pagamento dpp on dpp.cd_documento_pagar = dp.cd_documento_pagar
    where nep.cd_nota_entrada = @cd_nota_entrada and
      nep.cd_fornecedor = @cd_fornecedor and
      nep.cd_operacao_fiscal = @cd_operacao_fiscal and
      nep.cd_serie_nota_fiscal = @cd_serie_nota_fiscal

    open cPagamento

    fetch next from cPagamento into @cd_identificacao_parcela, @cd_doc_pagar, @dt_fato_gerador, @vl_pis_cofins_csll, @vl_tributado_imposto

    while @@fetch_status = 0
    begin
    
      -- Calcula o Vencimento e a Competência
      select @dt_vencimento = dbo.fn_calcula_vencimento_imposto(
                                @dt_fato_gerador,
                                qt_dia_pagto_imposto,
                                ic_tipo_pagamento_imposto, 'N' ),
             @dt_competencia = dbo.fn_calcula_vencimento_imposto(
                                 @dt_fato_gerador,
                                 qt_dia_pagto_imposto,
                                 ic_tipo_pagamento_imposto, 'S' ),
             @dt_inicio_competencia = dbo.fn_calcula_vencimento_imposto(
                               @dt_fato_gerador,
                               qt_dia_pagto_imposto,
                               ic_tipo_pagamento_imposto, 'I' )
      from #Imposto 
      where cd_imposto = 34 

      set @cd_item_retencao_imposto = @cd_item_retencao_imposto + 1
         
      -- Gerar os registros de Impostos Retidos na Nota de Entrada
      insert into Nota_Entrada_Retencao_Imposto (cd_nota_entrada, cd_fornecedor, cd_serie_nota_fiscal,
        cd_operacao_fiscal, cd_item_retencao_imposto, cd_documento_pagar, cd_imposto, cd_imposto_especificacao, 
        cd_receita_tributo, cd_darf_codigo, dt_fato_gerador, dt_inicio_apuracao, dt_apuracao_imposto, dt_vencimento_imposto, 
        vl_imposto_retido, cd_usuario, dt_usuario, vl_tributado_imposto, cd_identificacao_parcela)
      select @cd_nota_entrada, @cd_fornecedor, @cd_serie_nota_fiscal, @cd_operacao_fiscal, @cd_item_retencao_imposto,
        @cd_doc_pagar, cd_imposto, cd_imposto_especificacao, cd_receita_tributo, cd_darf_codigo, @dt_fato_gerador, 
--        @dt_inicio_competencia, @dt_competencia, @dt_vencimento, @vl_pis_cofins_csll, @cd_usuario, getDate(), @vl_tributado_imposto, @cd_identificacao_parcela 
        @dt_inicio_competencia, @dt_competencia, @dt_vencimento, @vl_pis_cofins_csll, @cd_usuario, getDate(), @vl_tributado_imposto, null 
      from #Imposto where cd_imposto = 34     

      fetch next from cPagamento into @cd_identificacao_parcela, @cd_doc_pagar, @dt_fato_gerador, @vl_pis_cofins_csll, @vl_tributado_imposto

    end

    close cPagamento
    deallocate cPagamento
  end  

  drop table #Imposto
  drop table #Nota_Entrada_Retencao_Imposto
   
end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Estornar Títulos Gerados Automaticamente
-------------------------------------------------------------------------------
begin

  if exists (select top 1 'x'
             from documento_pagar_pagamento
             where cd_documento_pagar = @cd_documento_pagar)
  begin 
    raiserror('Já foi efetuado pagamento de um ou mais Documentos geradas anteriormente! Não foi possível gerar os Documentos novamente.', 16,1)
  end
  else
  begin
    delete from 
      Documento_Pagar 
    where 
      cd_documento_pagar = @cd_documento_pagar
  end

end
-------------------------------------------------------------------------------
if @ic_parametro = 3  -- Geração Automática do Contas a Pagar através da 
-- Informação de Retenção do Documento a Pagar
-------------------------------------------------------------------------------
begin

  set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

  select @cd_moeda = cd_moeda 
  from parametro_financeiro 
  where cd_empresa = dbo.fn_empresa()

  -----------------------------------------------------------------------------
  -- DADOS PARA A GERAÇÃO DO CONTAS A PAGAR
  -----------------------------------------------------------------------------

  -- Dados do Documento a Pagar de Origem
  declare cPagamentoDocPagar cursor for
  select 
    dpi.cd_imposto, dpi.dt_vencimento_imposto, dpi.dt_fato_gerador, dpi.vl_principal_imposto,
    rtrim(i.sg_imposto) 
--+ ' DARF '+isnull(dc.sg_darf_codigo,'')+' - ' + isnull(ed.sg_empresa_diversa,'') + ' - '+ isnull(dp.nm_observacao_documento,'') 
as nm_observacao,
    idp.cd_empresa_diversa, idp.cd_favorecido_empresa, idp.cd_tipo_documento, idp.cd_tipo_conta_pagar, 
    idp.cd_plano_financeiro, dpi.dt_vencimento_imposto
  from Documento_Pagar dp inner join 
    Documento_Pagar_Imposto dpi on dp.cd_documento_pagar = dpi.cd_documento_pagar inner join 
    Imposto i on dpi.cd_imposto = i.cd_imposto inner join 
    Imposto_Documento_Pagar idp on i.cd_imposto = idp.cd_imposto left outer join
    Darf_Codigo dc on dc.cd_darf_codigo = dpi.cd_darf_codigo left outer join
    Empresa_Diversa ed on ed.cd_empresa_diversa = dp.cd_empresa_diversa
  where dp.cd_documento_pagar = @cd_documento_pagar and
    i.ic_gera_scp_imposto = 'S' 
  order by dpi.dt_vencimento_imposto

  -- Chave Original para Atualização da Retenção com o Código do Documento Gerado
  set @cd_chave = @cd_documento_pagar

  open cPagamentoDocPagar

  fetch next from cPagamentoDocPagar into @cd_imposto, @dt_vencimento, @dt_fato_gerador,
    @vl_imposto, @nm_observacao, @cd_empresa_diversa, @cd_favorecido_empresa, 
    @cd_tipo_documento, @cd_tipo_conta_pagar, @cd_plano_financeiro, @dt_vencimento

  while @@fetch_status = 0
  begin

    -- Chave e Código do Novo Documento
    set @cd_empresa = dbo.fn_empresa()
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento_pagar output
    exec dbo.pr_novo_documento_diverso 14, @cd_identificacao

    -- Grava o Documento a Pagar  
    insert into Documento_Pagar (cd_documento_pagar, cd_identificacao_document, dt_emissao_documento_paga,
      dt_vencimento_documento, vl_documento_pagar, cd_nota_fiscal_entrada, cd_serie_nota_fiscal_entr,
      nm_observacao_documento, vl_saldo_documento_pagar, cd_tipo_documento, cd_tipo_conta_pagar,
      cd_fornecedor, cd_usuario, dt_usuario, cd_plano_financeiro, nm_fantasia_fornecedor, cd_imposto,
      cd_empresa_diversa, cd_favorecido_empresa, cd_moeda)
    values (@cd_documento_pagar, 'DIV-'+@cd_identificacao, getDate(),
      @dt_vencimento, @vl_imposto, null, null,
      @nm_observacao, @vl_imposto, @cd_tipo_documento, @cd_tipo_conta_pagar, null,
      @cd_usuario, getDate(), @cd_plano_financeiro, null, @cd_imposto,
      @cd_empresa_diversa, @cd_favorecido_empresa, @cd_moeda)

    -- Atualiza o Documento_Pagar_Imposto que está originando o Contas a Pagar
    update Documento_Pagar_Imposto
    set cd_documento_pagar_gerado = @cd_documento_pagar
    where cd_documento_pagar = @cd_chave and
      cd_imposto = @cd_imposto

    -- Limpando tabela de Códigos
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_pagar, 'D'   

    fetch next from cPagamentoDocPagar into @cd_imposto, @dt_vencimento, @dt_fato_gerador,
      @vl_imposto, @nm_observacao, @cd_empresa_diversa, @cd_favorecido_empresa, 
      @cd_tipo_documento, @cd_tipo_conta_pagar, @cd_plano_financeiro, @dt_vencimento

  end

  close cPagamentoDocPagar
  deallocate cPagamentoDocPagar

end