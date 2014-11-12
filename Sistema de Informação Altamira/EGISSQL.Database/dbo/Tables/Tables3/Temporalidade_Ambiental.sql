CREATE TABLE [dbo].[Temporalidade_Ambiental] (
    [cd_temporalidade] INT          NOT NULL,
    [nm_temporalidade] VARCHAR (40) NULL,
    [sg_temporalidade] CHAR (10)    NULL,
    [ds_temporalidade] TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Temporalidade_Ambiental] PRIMARY KEY CLUSTERED ([cd_temporalidade] ASC) WITH (FILLFACTOR = 90)
);

