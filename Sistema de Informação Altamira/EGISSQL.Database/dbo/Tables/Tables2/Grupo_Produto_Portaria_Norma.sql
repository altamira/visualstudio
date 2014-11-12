CREATE TABLE [dbo].[Grupo_Produto_Portaria_Norma] (
    [cd_grupo_produto_portaria] INT          NOT NULL,
    [cd_grupo_produto]          INT          NOT NULL,
    [cd_portaria_norma]         INT          NOT NULL,
    [ds_grupo_produto_portaria] TEXT         NULL,
    [nm_obs_grupo_portaria]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Produto_Portaria_Norma] PRIMARY KEY CLUSTERED ([cd_grupo_produto_portaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Portaria_Norma_Portaria_Norma] FOREIGN KEY ([cd_portaria_norma]) REFERENCES [dbo].[Portaria_Norma] ([cd_portaria_norma])
);

