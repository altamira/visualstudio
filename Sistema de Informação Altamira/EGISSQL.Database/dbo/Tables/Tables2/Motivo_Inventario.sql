CREATE TABLE [dbo].[Motivo_Inventario] (
    [cd_motivo_inventario] INT          NOT NULL,
    [nm_motivo_inventario] VARCHAR (40) NULL,
    [sg_motivo_inventario] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Inventario] PRIMARY KEY CLUSTERED ([cd_motivo_inventario] ASC) WITH (FILLFACTOR = 90)
);

