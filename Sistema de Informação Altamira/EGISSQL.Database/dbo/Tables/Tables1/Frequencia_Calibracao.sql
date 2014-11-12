CREATE TABLE [dbo].[Frequencia_Calibracao] (
    [cd_frequencia_calibracao] INT          NOT NULL,
    [nm_frequencia_calibracao] VARCHAR (40) NULL,
    [sg_frequencia_calibracao] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [qt_dia_calibracao]        FLOAT (53)   NULL,
    CONSTRAINT [PK_Frequencia_Calibracao] PRIMARY KEY CLUSTERED ([cd_frequencia_calibracao] ASC) WITH (FILLFACTOR = 90)
);

