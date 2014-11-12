CREATE TABLE [dbo].[Incidencia_Ambiental] (
    [cd_incidencia_ambiental] INT          NOT NULL,
    [nm_incidencia_ambiental] VARCHAR (40) NULL,
    [sg_incidencia_ambiental] CHAR (10)    NULL,
    [ds_incidencia_ambiental] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Incidencia_Ambiental] PRIMARY KEY CLUSTERED ([cd_incidencia_ambiental] ASC) WITH (FILLFACTOR = 90)
);

