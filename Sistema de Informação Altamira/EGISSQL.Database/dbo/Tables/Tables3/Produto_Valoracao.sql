CREATE TABLE [dbo].[Produto_Valoracao] (
    [cd_produto]               INT      NOT NULL,
    [cd_fase_produto]          INT      NOT NULL,
    [cd_metodo_valoracao]      INT      NOT NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [cd_tipo_grupo_inventario] INT      NULL,
    [cd_lancamento_padrao]     INT      NULL,
    CONSTRAINT [PK_Produto_Valoracao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_fase_produto] ASC, [cd_metodo_valoracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Valoracao_Metodo_Valoracao] FOREIGN KEY ([cd_metodo_valoracao]) REFERENCES [dbo].[Metodo_Valoracao] ([cd_metodo_valoracao])
);

