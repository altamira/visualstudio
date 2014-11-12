CREATE TABLE [dbo].[RNC_Composicao] (
    [cd_rnc]                INT          NOT NULL,
    [cd_item_rnc]           INT          NOT NULL,
    [qt_item_rnc]           FLOAT (53)   NULL,
    [qt_item_aprovado_rnc]  FLOAT (53)   NULL,
    [cd_criterio_acao]      INT          NULL,
    [cd_acao_corretiva]     INT          NULL,
    [qt_item_reprovado_rnc] FLOAT (53)   NULL,
    [nm_obs_item_rnc]       VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_fornecedor]         INT          NULL,
    [cd_nota_entrada]       INT          NULL,
    [cd_operacao_fiscal]    INT          NULL,
    [cd_serie_nota_fiscal]  INT          NULL,
    [cd_item_nota_entrada]  INT          NULL,
    [cd_nota_saida]         INT          NULL,
    [cd_item_nota_saida]    INT          NULL,
    CONSTRAINT [PK_RNC_Composicao] PRIMARY KEY CLUSTERED ([cd_rnc] ASC, [cd_item_rnc] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RNC_Composicao_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

