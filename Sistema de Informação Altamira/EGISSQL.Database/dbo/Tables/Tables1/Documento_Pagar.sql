CREATE TABLE [dbo].[Documento_Pagar] (
    [cd_documento_pagar]             INT          NOT NULL,
    [cd_identificacao_document]      VARCHAR (30) NOT NULL,
    [dt_emissao_documento_paga]      DATETIME     NULL,
    [dt_vencimento_documento]        DATETIME     NULL,
    [vl_documento_pagar]             FLOAT (53)   NULL,
    [dt_cancelamento_documento]      DATETIME     NULL,
    [nm_cancelamento_documento]      VARCHAR (60) NULL,
    [cd_nota_fiscal_entrada]         VARCHAR (20) NULL,
    [cd_serie_nota_fiscal_entr]      CHAR (10)    NULL,
    [nm_numero_bancario]             VARCHAR (20) NULL,
    [nm_observacao_documento]        VARCHAR (60) NULL,
    [vl_saldo_documento_pagar]       FLOAT (53)   NULL,
    [dt_contabil_documento_pag]      DATETIME     NULL,
    [cd_empresa_diversa]             INT          NULL,
    [cd_favorecido_empresa]          INT          NULL,
    [cd_empresa]                     INT          NULL,
    [cd_funcionario]                 INT          NULL,
    [cd_contrato_pagar]              INT          NULL,
    [cd_tipo_documento]              INT          NULL,
    [cd_tipo_conta_pagar]            INT          NULL,
    [cd_fornecedor]                  INT          NULL,
    [cd_usuario]                     INT          NULL,
    [dt_usuario]                     DATETIME     NULL,
    [cd_identificacao_sap]           VARCHAR (30) NULL,
    [cd_pedido_compra]               INT          NULL,
    [cd_plano_financeiro]            INT          NULL,
    [vl_juros_documento]             FLOAT (53)   NULL,
    [vl_abatimento_documento]        FLOAT (53)   NULL,
    [vl_desconto_documento]          FLOAT (53)   NULL,
    [nm_fantasia_fornecedor]         CHAR (15)    NULL,
    [cd_tipo_pagamento]              INT          NULL,
    [dt_fluxo_docto_pagar]           DATETIME     NULL,
    [ic_fluxo_caixa]                 CHAR (1)     NULL,
    [cd_cheque_pagar]                INT          NULL,
    [cd_nota_saida]                  INT          NULL,
    [nm_motivo_dev_documento]        VARCHAR (40) NULL,
    [dt_devolucao_documento]         DATETIME     NULL,
    [cd_portador]                    INT          NULL,
    [dt_envio_banco_documento]       DATETIME     NULL,
    [dt_retorno_banco_doc]           DATETIME     NULL,
    [ic_envio_documento]             CHAR (1)     NULL,
    [cd_arquivo_magnetico]           INT          NULL,
    [cd_serie_nota_fiscal]           INT          NULL,
    [cd_numero_banco_documento]      INT          NULL,
    [cd_receita_darf]                VARCHAR (6)  NULL,
    [cd_competencia_gps]             VARCHAR (7)  NULL,
    [cd_tipo_pagto_eletronico]       INT          NULL,
    [cd_forma_pagto_eletronica]      INT          NULL,
    [cd_imposto]                     INT          NULL,
    [cd_moeda]                       INT          NULL,
    [cd_embarque_chave]              INT          NULL,
    [dt_selecao_documento]           DATETIME     NULL,
    [cd_loja]                        INT          NULL,
    [vl_documento_pagar_moeda]       FLOAT (53)   NULL,
    [cd_invoice]                     INT          NULL,
    [pc_imposto_documento]           FLOAT (53)   NULL,
    [cd_fechamento_cambio]           INT          NULL,
    [vl_tarifa_contrato_cambio]      FLOAT (53)   NULL,
    [vl_saldo_anterior_fecha_cambio] FLOAT (53)   NULL,
    [ic_deposito_documento]          CHAR (1)     NULL,
    [ic_tipo_deposito]               CHAR (1)     NULL,
    [cd_centro_custo]                INT          NULL,
    [vl_multa_documento]             FLOAT (53)   NULL,
    [cd_darf_automatico]             INT          NULL,
    [selecao]                        VARCHAR (1)  NULL,
    [nm_selecao]                     VARCHAR (1)  NULL,
    [cd_selecao]                     INT          NULL,
    [dt_envio_banco]                 DATETIME     NULL,
    [cd_tipo_movimento]              INT          NULL,
    [cd_conta_banco_pagamento]       INT          NULL,
    [dt_pagamento_documento]         DATETIME     NULL,
    [vl_pagamento_documento]         FLOAT (53)   NULL,
    [cd_situacao_documento]          INT          NULL,
    [cd_cheque_terceiro]             INT          NULL,
    [cd_ap]                          INT          NULL,
    [ic_sel_ap]                      CHAR (1)     NULL,
    [dt_vencimento_original]         DATETIME     NULL,
    [ic_previsao_documento]          CHAR (1)     NULL,
    [nm_complemento_documento]       VARCHAR (60) NULL,
    [cd_pedido_importacao]           INT          NULL,
    [cd_tipo_fluxo_caixa]            INT          NULL,
    [nm_ref_documento_pagar]         VARCHAR (10) NULL,
    [cd_tipo_destinatario]           INT          NULL,
    CONSTRAINT [PK_Documento_Pagar] PRIMARY KEY CLUSTERED ([cd_documento_pagar] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Pagar_Forma_Pagto_Eletronica] FOREIGN KEY ([cd_forma_pagto_eletronica]) REFERENCES [dbo].[Forma_Pagto_Eletronica] ([cd_forma_pagto_eletronica]),
    CONSTRAINT [FK_Documento_Pagar_Tipo_Pagto_Eletronico] FOREIGN KEY ([cd_tipo_pagto_eletronico]) REFERENCES [dbo].[Tipo_Pagto_Eletronico] ([cd_tipo_pagto_eletronico])
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_identificacao_document]
    ON [dbo].[Documento_Pagar]([cd_identificacao_document] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_dt_vencimento_documento]
    ON [dbo].[Documento_Pagar]([dt_vencimento_documento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Financeiro_Documento_Pagar]
    ON [dbo].[Documento_Pagar]([cd_plano_financeiro] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Documento_Pagar]
    ON [dbo].[Documento_Pagar]([dt_vencimento_documento] ASC, [dt_cancelamento_documento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_documento_pagar_Identificacao]
    ON [dbo].[Documento_Pagar]([cd_identificacao_document] ASC);

