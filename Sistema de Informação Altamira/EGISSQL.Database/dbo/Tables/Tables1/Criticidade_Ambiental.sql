CREATE TABLE [dbo].[Criticidade_Ambiental] (
    [cd_criticidade] INT          NOT NULL,
    [nm_criticidade] VARCHAR (40) NULL,
    [sg_criticidade] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Criticidade_Ambiental] PRIMARY KEY CLUSTERED ([cd_criticidade] ASC) WITH (FILLFACTOR = 90)
);

