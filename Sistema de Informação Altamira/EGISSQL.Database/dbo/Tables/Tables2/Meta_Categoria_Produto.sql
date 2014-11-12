CREATE TABLE [dbo].[Meta_Categoria_Produto] (
    [dt_inicial_meta_categoria] DATETIME   NOT NULL,
    [dt_final_meta_categoria]   DATETIME   NOT NULL,
    [cd_categoria_produto]      INT        NOT NULL,
    [vl_fat_meta_categoria]     FLOAT (53) NOT NULL,
    [vl_ven_meta_categoria]     FLOAT (53) NOT NULL,
    [qt_fat_meta_categoria]     INT        NOT NULL,
    [qt_ven_meta_categoria]     INT        NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Meta_Categoria_Produto] PRIMARY KEY CLUSTERED ([dt_inicial_meta_categoria] ASC, [dt_final_meta_categoria] ASC, [cd_categoria_produto] ASC) WITH (FILLFACTOR = 90)
);

