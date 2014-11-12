CREATE TABLE [dbo].[Produto_Classificacao] (
    [cd_produto]                   INT          NOT NULL,
    [cd_classificacao_produto]     INT          NOT NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [cd_tipo_produto]              INT          NULL,
    [cd_classificacao]             INT          NULL,
    [cd_classificacao_abisolo]     INT          NULL,
    [nm_obs_produto_classificacao] VARCHAR (60) NULL,
    CONSTRAINT [PK_Produto_Classificacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_classificacao_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Classificacao_Abisolo_Classificacao] FOREIGN KEY ([cd_classificacao_abisolo]) REFERENCES [dbo].[Abisolo_Classificacao] ([cd_classificacao_abisolo]),
    CONSTRAINT [FK_Produto_Classificacao_Agricultura_Classificacao] FOREIGN KEY ([cd_classificacao]) REFERENCES [dbo].[Agricultura_Classificacao] ([cd_classificacao]),
    CONSTRAINT [FK_Produto_Classificacao_Agricultura_Tipo_Produto] FOREIGN KEY ([cd_tipo_produto]) REFERENCES [dbo].[Agricultura_Tipo_Produto] ([cd_tipo_produto]),
    CONSTRAINT [FK_Produto_Classificacao_Classificacao_Produto] FOREIGN KEY ([cd_classificacao_produto]) REFERENCES [dbo].[Classificacao_Produto] ([cd_classificacao_produto])
);

