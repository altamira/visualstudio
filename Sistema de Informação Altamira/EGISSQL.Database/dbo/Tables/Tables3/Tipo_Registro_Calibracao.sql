CREATE TABLE [dbo].[Tipo_Registro_Calibracao] (
    [cd_tipo_registro] INT          NOT NULL,
    [nm_tipo_registro] VARCHAR (40) NULL,
    [sg_tipo_registro] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Registro_Calibracao] PRIMARY KEY CLUSTERED ([cd_tipo_registro] ASC) WITH (FILLFACTOR = 90)
);

