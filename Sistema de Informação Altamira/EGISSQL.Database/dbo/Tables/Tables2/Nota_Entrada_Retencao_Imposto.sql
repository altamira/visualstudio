CREATE TABLE [dbo].[Nota_Entrada_Retencao_Imposto] (
    [cd_fornecedor]            INT        NOT NULL,
    [cd_nota_entrada]          INT        NOT NULL,
    [cd_serie_nota_fiscal]     INT        NOT NULL,
    [cd_operacao_fiscal]       INT        NOT NULL,
    [cd_documento_pagar]       INT        NOT NULL,
    [cd_item_retencao_imposto] INT        NOT NULL,
    [cd_imposto]               INT        NULL,
    [cd_imposto_especificacao] INT        NULL,
    [cd_receita_tributo]       INT        NULL,
    [cd_darf_codigo]           INT        NULL,
    [dt_fato_gerador]          DATETIME   NULL,
    [dt_apuracao_imposto]      DATETIME   NULL,
    [dt_vencimento_imposto]    DATETIME   NULL,
    [vl_imposto_retido]        FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [vl_tributado_imposto]     FLOAT (53) NULL,
    [dt_inicio_apuracao]       DATETIME   NULL,
    [cd_identificacao_parcela] INT        NULL,
    CONSTRAINT [PK_Nota_Entrada_Retencao_Imposto] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_nota_entrada] ASC, [cd_serie_nota_fiscal] ASC, [cd_operacao_fiscal] ASC, [cd_documento_pagar] ASC, [cd_item_retencao_imposto] ASC) WITH (FILLFACTOR = 90)
);

