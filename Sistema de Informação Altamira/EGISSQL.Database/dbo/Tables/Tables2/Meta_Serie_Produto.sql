CREATE TABLE [dbo].[Meta_Serie_Produto] (
    [dt_inicial_meta_serie]     DATETIME   NOT NULL,
    [dt_final_meta_serie]       DATETIME   NOT NULL,
    [cd_serie_produto]          INT        NOT NULL,
    [vl_fat_meta_serie_produto] FLOAT (53) NOT NULL,
    [vl_ven_meta_serie_produto] FLOAT (53) NOT NULL,
    [qt_fat_meta_serie_produto] INT        NOT NULL,
    [qt_ven_meta_serie_produto] FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL
);

