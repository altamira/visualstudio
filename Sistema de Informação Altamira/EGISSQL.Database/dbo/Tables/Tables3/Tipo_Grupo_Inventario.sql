CREATE TABLE [dbo].[Tipo_Grupo_Inventario] (
    [cd_tipo_grupo_inventario] INT          NOT NULL,
    [nm_tipo_grupo_inventario] VARCHAR (50) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [sg_tipo_grupo_inventario] CHAR (10)    NULL,
    CONSTRAINT [PK_Tipo_Grupo_Inventario] PRIMARY KEY CLUSTERED ([cd_tipo_grupo_inventario] ASC) WITH (FILLFACTOR = 90)
);

