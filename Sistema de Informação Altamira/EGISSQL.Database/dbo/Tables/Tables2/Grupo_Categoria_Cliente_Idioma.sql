CREATE TABLE [dbo].[Grupo_Categoria_Cliente_Idioma] (
    [cd_grupo_categ_Cliente] INT          NOT NULL,
    [cd_idioma]              INT          NOT NULL,
    [nm_idioma_grupo_categ]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL
);

