
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_multa_contas_pagar
-------------------------------------------------------------------------------
--pr_geracao_multa_contas_pagar
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Contas a Pagar com o Lançamento das Multas
--Data             : 23.12.2009
--Alteração        : 07.01.2009 - Ajustes Diversos - Carlos FErnand
--
--
------------------------------------------------------------------------------
create procedure pr_geracao_multa_contas_pagar
@cd_veiculo_multa int      = 0,
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_moeda         int      = 0,
@cd_usuario       int      = 0

as

  declare @cd_notificacao_multa      varchar(20)
  declare @dt_vencimento_documento   datetime 
  declare @vl_documento_pagar        decimal(25,2)
  declare @vl_desconto_documento     decimal(25,2)
  declare @dt_emissao_documento      datetime
  
  select 
    @cd_notificacao_multa    = isnull(cd_notificacao_multa,''),
    @dt_emissao_documento    = dt_veiculo_multa,
    @dt_vencimento_documento = dt_vencto_veiculo_multa,
    @vl_documento_pagar      = isnull(vl_veiculo_multa,0),
    @vl_desconto_documento   = isnull(vl_desconto_multa,0)
        
  from
    Veiculo_Multa vm with (nolock) 
  where
    cd_veiculo_multa = @cd_veiculo_multa and
    isnull(cd_documento_pagar,0)=0


--select @cd_veiculo_multa,@cd_notificacao_multa

if @cd_veiculo_multa > 0 and @cd_notificacao_multa<>'' 
begin

--select * from veiculo_multa

  declare @Tabela		     varchar(80)
  declare @cd_documento_pagar        int
  declare @cd_tipo_documento         int
  declare @cd_plano_financeiro       int
  declare @cd_situacao_documento     int
  declare @cd_tipo_conta_pagar       int
  declare @cd_portador               int
  declare @cd_empresa_diversa        int 
  declare @cd_centro_custo           int
  
  declare @cd_identificacao_document varchar(30)
    
  set @cd_identificacao_document = +cast(@cd_notificacao_multa as varchar)

  --Verifica se existe o Documento

  if not exists(select top 1 cd_identificacao_document from documento_pagar 
                where 
                  cd_identificacao_document = @cd_identificacao_document ) 

  begin

     --Busca os Parâmetros

     select
       @cd_tipo_documento     = isnull(cd_tipo_documento,0),
       @cd_plano_financeiro   = isnull(cd_plano_financeiro,0),
       @cd_centro_custo       = isnull(cd_centro_custo,0),
       @cd_situacao_documento = isnull(cd_situacao_documento,0),
       @cd_tipo_conta_pagar   = isnull(cd_tipo_conta_pagar,0),
       @cd_portador           = isnull(cd_portador,0),
       @cd_empresa_diversa    = isnull(cd_empresa_diversa,0)
     from
       Config_Multa_Documento_pagar with (nolock) 
     where
      cd_empresa = dbo.fn_empresa() 

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
      cast(@cd_notificacao_multa as varchar)       as cd_identificacao_document,
      @dt_emissao_documento                        as dt_emissao_documento_paga,
      --@dt_ap                                     as dt_vencimento_documento,
      @dt_vencimento_documento                     as dt_vencimento_documento,
      @vl_documento_pagar                          as vl_documento_pagar,
      null                                         as dt_cancelamento_documento,
      null                                         as nm_cancelamento_documento,
      null                                         as cd_nota_fiscal_entrada,
      null                                         as cd_serie_nota_fiscal_entr,
      null                                         as nm_numero_bancario,
      null                                         as nm_observacao_documento,
      @vl_documento_pagar                          as vl_saldo_documento_pagar,
      null                                         as dt_contabil_documento_pag,
      @cd_empresa_diversa                          as cd_empresa_diversa,
      null                                         as cd_favorecido_empresa,
      dbo.fn_empresa()                             as cd_empresa,
      null                                         as cd_funcionario,
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
      @vl_desconto_documento                       as vl_desconto_documento,
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
      null                                         as cd_pedido_importacao

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

    --Atualiza o Número do Documento a Pagar

    update
      Veiculo_Multa
    set
      cd_documento_pagar = @cd_documento_pagar
    where
      @cd_veiculo_multa  = cd_veiculo_multa
  end

  select @cd_documento_pagar

end


