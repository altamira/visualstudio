CREATE TABLE [dbo].[Inventario_Bem] (
    [cd_inventario]        INT          NOT NULL,
    [dt_inventario]        DATETIME     NULL,
    [nm_inventario]        VARCHAR (40) NULL,
    [cd_motivo_inventario] INT          NULL,
    [ds_inventario]        TEXT         NULL,
    [nm_obs_inventario]    VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_centro_custo]      INT          NULL,
    CONSTRAINT [PK_Inventario_Bem] PRIMARY KEY CLUSTERED ([cd_inventario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Inventario_Bem_Motivo_Inventario] FOREIGN KEY ([cd_motivo_inventario]) REFERENCES [dbo].[Motivo_Inventario] ([cd_motivo_inventario])
);

