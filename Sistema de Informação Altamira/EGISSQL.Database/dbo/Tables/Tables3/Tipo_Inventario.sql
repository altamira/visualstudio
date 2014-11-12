CREATE TABLE [dbo].[Tipo_Inventario] (
    [cd_tipo_inventario] INT          NOT NULL,
    [nm_tipo_inventario] VARCHAR (30) NULL,
    [sg_tipo_inventario] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Inventario] PRIMARY KEY CLUSTERED ([cd_tipo_inventario] ASC) WITH (FILLFACTOR = 90)
);

