CREATE TABLE [dbo].[Manut_Cem_Hist] (
    [cd_manut_cem_hist]        INT        NOT NULL,
    [qt_manut_cem_hist]        FLOAT (53) NULL,
    [qt_manut_gerada_cem_hist] FLOAT (53) NULL,
    [vl_total_manut_cem_hist]  FLOAT (53) NULL,
    [ds_manut_cem_hist]        TEXT       NULL,
    [cd_categoria_contrato]    INT        NULL,
    [dt_venc_manut_cem_hist]   DATETIME   NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_isent_manut_cem_hist]  FLOAT (53) NULL,
    CONSTRAINT [PK_Manut_Cem_Hist] PRIMARY KEY CLUSTERED ([cd_manut_cem_hist] ASC) WITH (FILLFACTOR = 90)
);

