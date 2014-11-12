CREATE TABLE [dbo].[Distancia_Diametro_Valor] (
    [cd_distancia_diametro_vl] INT        NOT NULL,
    [cd_tipo_distancia_diam]   INT        NOT NULL,
    [qt_distancia_diametro_vl] FLOAT (53) NOT NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Distancia_Diametro_Valor] PRIMARY KEY CLUSTERED ([cd_distancia_diametro_vl] ASC, [cd_tipo_distancia_diam] ASC) WITH (FILLFACTOR = 90)
);

