CREATE TABLE [dbo].[Fase_Processo_Juridico] (
    [cd_fase_processo] INT          NOT NULL,
    [nm_fase_processo] VARCHAR (40) NULL,
    [sg_fase_processo] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Fase_Processo_Juridico] PRIMARY KEY CLUSTERED ([cd_fase_processo] ASC) WITH (FILLFACTOR = 90)
);

