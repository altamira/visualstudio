CREATE TABLE [dbo].[Meta_Grupo_Categ] (
    [dt_inicial_meta_serie]     DATETIME   NOT NULL,
    [dt_final_meta_serie]       DATETIME   NOT NULL,
    [cd_grupo_categoria]        INT        NOT NULL,
    [vl_fat_meta_serie_produto] FLOAT (53) NOT NULL,
    [vl_ven_meta_serie_produto] FLOAT (53) NOT NULL,
    [qt_fat_meta_serie_produto] INT        NOT NULL,
    [qt_ven_meta_serie_produto] INT        NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Meta_Grupo_Categ] PRIMARY KEY CLUSTERED ([dt_inicial_meta_serie] ASC, [dt_final_meta_serie] ASC, [cd_grupo_categoria] ASC) WITH (FILLFACTOR = 90)
);

