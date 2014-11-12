CREATE TABLE [dbo].[Norma_Tecnica_Grupo_Produto] (
    [cd_norma_grupo_produto]     INT          NOT NULL,
    [cd_grupo_produto]           INT          NOT NULL,
    [cd_norma_tecnica]           INT          NOT NULL,
    [ds_norma_tecnica_grupo]     TEXT         NULL,
    [nm_obs_norma_tecnica_grupo] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Norma_Tecnica_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_norma_grupo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Norma_Tecnica_Grupo_Produto_Norma_Tecnica] FOREIGN KEY ([cd_norma_tecnica]) REFERENCES [dbo].[Norma_Tecnica] ([cd_norma_tecnica])
);

