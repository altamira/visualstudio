CREATE TABLE [dbo].[Modelo_Produto] (
    [cd_modelo_produto]       INT          NOT NULL,
    [nm_modelo_produto]       VARCHAR (60) NULL,
    [nm_fantasia_modelo]      VARCHAR (15) NULL,
    [sg_modelo_produto]       CHAR (10)    NULL,
    [cd_grupo_modelo_produto] INT          NULL,
    [ds_modelo_produto]       TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_item_composicao]      INT          NULL,
    [cd_portaria_norma]       INT          NULL,
    [cd_norma_construtiva]    INT          NULL,
    [ds_simplificado_modelo]  TEXT         NULL,
    [nm_sequencia_fantasia]   VARCHAR (30) NULL,
    CONSTRAINT [PK_Modelo_Produto] PRIMARY KEY CLUSTERED ([cd_modelo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modelo_Produto_Grupo_Modelo_Produto] FOREIGN KEY ([cd_grupo_modelo_produto]) REFERENCES [dbo].[Grupo_Modelo_Produto] ([cd_grupo_modelo_produto]),
    CONSTRAINT [FK_Modelo_Produto_Norma_Construtiva] FOREIGN KEY ([cd_norma_construtiva]) REFERENCES [dbo].[Norma_Construtiva] ([cd_norma_construtiva]),
    CONSTRAINT [FK_Modelo_Produto_Portaria_Norma] FOREIGN KEY ([cd_portaria_norma]) REFERENCES [dbo].[Portaria_Norma] ([cd_portaria_norma])
);

