CREATE TABLE [dbo].[Glossario_Tecnico] (
    [cd_glossario_tecnico] INT          NOT NULL,
    [sg_glossario_tecnico] VARCHAR (30) NULL,
    [ds_glossario_tecnico] TEXT         NULL,
    [ic_glossario_tecnico] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_modulo]            INT          NULL
);

