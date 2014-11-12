CREATE TABLE [dbo].[Grupo_Produto_Valoracao] (
    [cd_grupo_produto]         INT          NOT NULL,
    [cd_fase_produto]          INT          NOT NULL,
    [cd_item_valoracao_grupo]  INT          NOT NULL,
    [cd_metodo_valoracao]      INT          NULL,
    [nm_obs_valoracao_grupo]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_lancamento_padrao]     INT          NULL,
    [cd_tipo_grupo_inventario] INT          NULL,
    CONSTRAINT [PK_Grupo_Produto_Valoracao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_fase_produto] ASC, [cd_item_valoracao_grupo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Valoracao_Metodo_Valoracao] FOREIGN KEY ([cd_metodo_valoracao]) REFERENCES [dbo].[Metodo_Valoracao] ([cd_metodo_valoracao])
);

