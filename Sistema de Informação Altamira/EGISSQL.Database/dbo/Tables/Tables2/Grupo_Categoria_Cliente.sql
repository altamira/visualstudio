CREATE TABLE [dbo].[Grupo_Categoria_Cliente] (
    [cd_grupo_categ_cliente] INT          NOT NULL,
    [nm_grupo_categ_cliente] VARCHAR (40) NULL,
    [sg_grupo_categ_cliente] CHAR (10)    NULL,
    [cd_mascara_grupo_categ] VARCHAR (20) NULL,
    [ic_analise_grupo_categ] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL
);

