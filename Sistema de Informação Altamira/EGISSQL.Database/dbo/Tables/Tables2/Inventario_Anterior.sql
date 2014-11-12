CREATE TABLE [dbo].[Inventario_Anterior] (
    [cd_inventario_anterior]         INT          NOT NULL,
    [nm_inventario_anterior]         VARCHAR (50) NULL,
    [sg_inventario_anterior]         CHAR (10)    NULL,
    [dt_inicial_inventario_anterior] DATETIME     NULL,
    [dt_final_inventario_anterior]   DATETIME     NULL,
    [cd_inventario_anterior_ref]     INT          NOT NULL,
    [cd_usuario]                     INT          NULL,
    [dt_usuario]                     DATETIME     NULL,
    CONSTRAINT [PK_Inventario_Anterior] PRIMARY KEY CLUSTERED ([cd_inventario_anterior] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Inventario_Anterior_Inventario] FOREIGN KEY ([cd_inventario_anterior_ref]) REFERENCES [dbo].[Inventario] ([cd_inventario])
);

