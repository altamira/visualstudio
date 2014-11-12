CREATE TABLE [dbo].[Tipo_Calibracao] (
    [cd_tipo_calibracao] INT          NOT NULL,
    [nm_tipo_calibracao] VARCHAR (40) NULL,
    [sg_tipo_calibracao] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Calibracao] PRIMARY KEY CLUSTERED ([cd_tipo_calibracao] ASC) WITH (FILLFACTOR = 90)
);

