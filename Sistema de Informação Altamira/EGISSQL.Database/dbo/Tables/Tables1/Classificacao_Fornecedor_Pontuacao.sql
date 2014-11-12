CREATE TABLE [dbo].[Classificacao_Fornecedor_Pontuacao] (
    [cd_classif_fornecedor] INT          NOT NULL,
    [cd_item_classificação] INT          NOT NULL,
    [qt_pontuacao_inicial]  FLOAT (53)   NULL,
    [qt_pontuacao_final]    FLOAT (53)   NULL,
    [nm_obs_pontuacao]      VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Fornecedor_Pontuacao] PRIMARY KEY CLUSTERED ([cd_classif_fornecedor] ASC, [cd_item_classificação] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Classificacao_Fornecedor_Pontuacao_Classificacao_Fornecedor] FOREIGN KEY ([cd_classif_fornecedor]) REFERENCES [dbo].[Classificacao_Fornecedor] ([cd_classif_fornecedor])
);

