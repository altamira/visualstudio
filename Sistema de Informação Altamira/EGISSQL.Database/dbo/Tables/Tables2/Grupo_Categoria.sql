CREATE TABLE [dbo].[Grupo_Categoria] (
    [cd_grupo_categoria]    INT          NOT NULL,
    [nm_grupo_categoria]    VARCHAR (40) NULL,
    [sg_grupo_categoria]    CHAR (10)    NOT NULL,
    [cd_mascara_grupo]      VARCHAR (20) NOT NULL,
    [ic_exportacao_grupo]   CHAR (1)     NOT NULL,
    [ic_analise_grupo]      CHAR (1)     NOT NULL,
    [cd_tipo_grupo_produto] INT          NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Grupo_Categoria] PRIMARY KEY CLUSTERED ([cd_grupo_categoria] ASC) WITH (FILLFACTOR = 90)
);

