CREATE TABLE [dbo].[Tipo_Residuo] (
    [cd_tipo_residuo]     INT          NOT NULL,
    [nm_tipo_residuo]     VARCHAR (40) NULL,
    [sg_tipo_residuo]     CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ds_tipo_residuo]     TEXT         NULL,
    [nm_obs_tipo_residuo] VARCHAR (40) NULL,
    CONSTRAINT [PK_Tipo_Residuo] PRIMARY KEY CLUSTERED ([cd_tipo_residuo] ASC) WITH (FILLFACTOR = 90)
);

