CREATE TABLE [dbo].[Prioridade_Pendencia] (
    [cd_prioridade_pendencia] INT          NOT NULL,
    [nm_prioridade_pendencia] VARCHAR (40) NULL,
    [sg_prioridade_pendencia] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Prioridade_Pendencia] PRIMARY KEY CLUSTERED ([cd_prioridade_pendencia] ASC) WITH (FILLFACTOR = 90)
);

