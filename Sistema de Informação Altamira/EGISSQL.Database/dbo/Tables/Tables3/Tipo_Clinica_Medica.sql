CREATE TABLE [dbo].[Tipo_Clinica_Medica] (
    [cd_tipo_clinica_medica] INT          NOT NULL,
    [nm_tipo_clinica_medica] VARCHAR (30) NULL,
    [sg_tipo_clinica_medica] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Clinica_Medica] PRIMARY KEY CLUSTERED ([cd_tipo_clinica_medica] ASC) WITH (FILLFACTOR = 90)
);

