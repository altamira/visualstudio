CREATE TABLE [dbo].[Meta_Categoria_Cliente] (
    [dt_inicial_meta_categoria] DATETIME   NOT NULL,
    [dt_final_meta_categoria]   DATETIME   NOT NULL,
    [cd_categoria_cliente]      INT        NOT NULL,
    [vl_fat_meta_categoria]     FLOAT (53) NULL,
    [vl_ven_meta_categoria]     FLOAT (53) NULL,
    [qt_fat_meta_categoria]     FLOAT (53) NULL,
    [qt_ven_meta_categoria]     FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Meta_Categoria_Cliente] PRIMARY KEY CLUSTERED ([dt_inicial_meta_categoria] ASC, [dt_final_meta_categoria] ASC, [cd_categoria_cliente] ASC) WITH (FILLFACTOR = 90)
);

