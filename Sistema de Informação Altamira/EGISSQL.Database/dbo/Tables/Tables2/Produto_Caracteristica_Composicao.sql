CREATE TABLE [dbo].[Produto_Caracteristica_Composicao] (
    [cd_produto]                    INT          NOT NULL,
    [cd_caracteristica_produto]     INT          NOT NULL,
    [qt_ordem_produto]              INT          NOT NULL,
    [nm_produto_caracteristica]     VARCHAR (60) NULL,
    [qt_produto_caracterisitca]     FLOAT (53)   NULL,
    [ds_produto_caracteristica]     TEXT         NULL,
    [nm_obs_produto_caracteristica] VARCHAR (40) NULL,
    [cd_produto_composicao]         INT          NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    CONSTRAINT [PK_Produto_Caracteristica_Composicao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_caracteristica_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Caracteristica_Composicao_Produto] FOREIGN KEY ([cd_produto_composicao]) REFERENCES [dbo].[Produto] ([cd_produto])
);

