CREATE TABLE [dbo].[Grupo_Produto_Fase] (
    [cd_grupo_produto]   INT          NOT NULL,
    [cd_fase_produto]    INT          NOT NULL,
    [cd_item_grupo_fase] INT          NOT NULL,
    [nm_obs_fase_grupo]  VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Produto_Fase] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_fase_produto] ASC, [cd_item_grupo_fase] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Fase_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

