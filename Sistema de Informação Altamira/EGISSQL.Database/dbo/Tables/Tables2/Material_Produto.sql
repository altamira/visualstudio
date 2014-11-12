CREATE TABLE [dbo].[Material_Produto] (
    [cd_grupo_produto]        INT          NOT NULL,
    [cd_material_produto]     INT          NOT NULL,
    [nm_material_produto]     VARCHAR (60) NULL,
    [sg_material_produto]     CHAR (10)    NULL,
    [cd_ordem_material]       INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_obs_material_produto] VARCHAR (40) NULL,
    [ic_tipo_material]        CHAR (1)     NULL,
    CONSTRAINT [PK_Material_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_material_produto] ASC),
    CONSTRAINT [FK_Material_Produto_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

