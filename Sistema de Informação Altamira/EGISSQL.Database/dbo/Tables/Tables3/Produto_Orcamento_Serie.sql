CREATE TABLE [dbo].[Produto_Orcamento_Serie] (
    [cd_produto]              INT          NULL,
    [cd_serie_produto]        INT          NULL,
    [cd_item_orcamento_serie] INT          NOT NULL,
    [qt_serie_produto]        FLOAT (53)   NULL,
    [nm_obs_serie_produto]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Produto_Orcamento_Serie] PRIMARY KEY CLUSTERED ([cd_item_orcamento_serie] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Orcamento_Serie_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto]),
    CONSTRAINT [FK_Produto_Orcamento_Serie_Serie_Produto] FOREIGN KEY ([cd_serie_produto]) REFERENCES [dbo].[Serie_Produto] ([cd_serie_produto])
);

