CREATE TABLE [dbo].[Inventario] (
    [cd_inventario]             INT          NOT NULL,
    [dt_base_inventario]        DATETIME     NULL,
    [nm_obs_inventario]         VARCHAR (40) NULL,
    [cd_tipo_inventario]        INT          NULL,
    [qt_tot_produto_inventario] INT          NULL,
    [vl_total_inventario]       FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Inventario] PRIMARY KEY CLUSTERED ([cd_inventario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Inventario_Tipo_Inventario] FOREIGN KEY ([cd_tipo_inventario]) REFERENCES [dbo].[Tipo_Inventario] ([cd_tipo_inventario])
);

