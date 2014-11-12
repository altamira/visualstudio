CREATE TABLE [dbo].[Escala_Ambiental] (
    [cd_escala_ambiental] INT          NOT NULL,
    [nm_escala_ambiental] VARCHAR (40) NULL,
    [ds_escala_ambiental] TEXT         NULL,
    [qt_escala_ambiental] FLOAT (53)   NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Escala_Ambiental] PRIMARY KEY CLUSTERED ([cd_escala_ambiental] ASC) WITH (FILLFACTOR = 90)
);

