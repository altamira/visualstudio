CREATE TABLE [dbo].[Prioridade_Tarefa] (
    [cd_prioridade_tarefa] INT          NOT NULL,
    [nm_prioridade_tarefa] VARCHAR (40) NULL,
    [sg_prioridade_tarefa] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuário]           DATETIME     NULL,
    CONSTRAINT [PK_Prioridade_Tarefa] PRIMARY KEY CLUSTERED ([cd_prioridade_tarefa] ASC) WITH (FILLFACTOR = 90)
);

