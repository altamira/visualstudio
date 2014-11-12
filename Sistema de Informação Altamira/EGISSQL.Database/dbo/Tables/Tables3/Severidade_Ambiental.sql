CREATE TABLE [dbo].[Severidade_Ambiental] (
    [cd_severidade_ambiental] INT          NOT NULL,
    [nm_severidade_ambiental] VARCHAR (40) NULL,
    [sg_severidade_ambiental] CHAR (10)    NULL,
    [ds_severidade_ambiental] TEXT         NULL,
    [qt_severidade_ambiental] FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Severidade_Ambiental] PRIMARY KEY CLUSTERED ([cd_severidade_ambiental] ASC) WITH (FILLFACTOR = 90)
);

