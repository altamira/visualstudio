CREATE TABLE [dbo].[Especialidade_Medica] (
    [cd_especialidade_medica] INT          NOT NULL,
    [nm_especialidade_medica] VARCHAR (50) NULL,
    [sg_especialidade_medica] CHAR (10)    NULL,
    [cd_cid10]                INT          NULL,
    [vl_especialidade_medica] FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Especialidade_Medica] PRIMARY KEY CLUSTERED ([cd_especialidade_medica] ASC) WITH (FILLFACTOR = 90)
);

