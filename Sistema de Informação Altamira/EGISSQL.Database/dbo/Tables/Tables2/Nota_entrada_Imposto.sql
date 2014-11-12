CREATE TABLE [dbo].[Nota_entrada_Imposto] (
    [cd_fornecedor]            INT      NOT NULL,
    [cd_nota_entrada]          INT      NOT NULL,
    [cd_operacao_fiscal]       INT      NOT NULL,
    [cd_serie_nota_fiscal]     INT      NOT NULL,
    [cd_imposto]               INT      NOT NULL,
    [cd_imposto_especificacao] INT      NULL,
    [cd_receita_tributo]       INT      NULL,
    [cd_darf_codigo]           INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Nota_entrada_Imposto] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_nota_entrada] ASC, [cd_operacao_fiscal] ASC, [cd_serie_nota_fiscal] ASC, [cd_imposto] ASC) WITH (FILLFACTOR = 90)
);

