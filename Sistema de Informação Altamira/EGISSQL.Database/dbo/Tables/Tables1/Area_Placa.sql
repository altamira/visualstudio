CREATE TABLE [dbo].[Area_Placa] (
    [cd_area_placa]         INT          NOT NULL,
    [qt_inicial_area_placa] FLOAT (53)   NULL,
    [qt_final_area_placa]   FLOAT (53)   NULL,
    [cd_tipo_lucro]         INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [nm_obs_area_placa]     VARCHAR (40) NULL,
    CONSTRAINT [PK_Area_Placa] PRIMARY KEY CLUSTERED ([cd_area_placa] ASC) WITH (FILLFACTOR = 90)
);

