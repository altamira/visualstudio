CREATE TABLE [dbo].[Serie_Produto_Categoria] (
    [cd_serie_produto]          INT          NOT NULL,
    [cd_categoria_produto]      INT          NOT NULL,
    [cd_agrupamento_produto]    INT          NOT NULL,
    [cd_classificacao_fiscal]   INT          NULL,
    [nm_obs_serie_prod_categor] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Serie_Produto_Categoria] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_categoria_produto] ASC, [cd_agrupamento_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Produto_Categoria_Agrupamento_Produto] FOREIGN KEY ([cd_agrupamento_produto]) REFERENCES [dbo].[Agrupamento_Produto] ([cd_agrupamento_produto]),
    CONSTRAINT [FK_Serie_Produto_Categoria_Classificacao_Fiscal] FOREIGN KEY ([cd_classificacao_fiscal]) REFERENCES [dbo].[Classificacao_Fiscal] ([cd_classificacao_fiscal])
);

