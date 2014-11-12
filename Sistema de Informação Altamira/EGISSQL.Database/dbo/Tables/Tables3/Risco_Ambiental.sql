CREATE TABLE [dbo].[Risco_Ambiental] (
    [cd_risco_ambiental] INT          NOT NULL,
    [nm_risco_ambiental] VARCHAR (40) NULL,
    [sg_risco_ambiental] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Risco_Ambiental] PRIMARY KEY CLUSTERED ([cd_risco_ambiental] ASC) WITH (FILLFACTOR = 90)
);

