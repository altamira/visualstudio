CREATE TABLE [dbo].[Config_Etiqueta] (
    [cd_config_etiqueta]        INT          NOT NULL,
    [nm_config_etiqueta]        VARCHAR (30) NOT NULL,
    [vl_larg_config_etiqueta]   FLOAT (53)   NULL,
    [vl_comp_config_etiqueta]   FLOAT (53)   NULL,
    [vl_mg_sup_config_etiqueta] FLOAT (53)   NULL,
    [vl_mg_inf_config_etiqueta] FLOAT (53)   NULL,
    [vl_mg_dir_config_etiqueta] FLOAT (53)   NULL,
    [vl_mg_esq_config_etiqueta] FLOAT (53)   NULL,
    [qt_etiq_config_etiqueta]   INT          NULL,
    [cd_tipo_papel]             INT          NULL,
    [ds_config_etiqueta]        TEXT         NULL,
    CONSTRAINT [PK_Config_Etiqueta] PRIMARY KEY CLUSTERED ([cd_config_etiqueta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_Etiqueta_Tipo_Papel] FOREIGN KEY ([cd_tipo_papel]) REFERENCES [dbo].[Tipo_Papel] ([cd_tipo_papel])
);

