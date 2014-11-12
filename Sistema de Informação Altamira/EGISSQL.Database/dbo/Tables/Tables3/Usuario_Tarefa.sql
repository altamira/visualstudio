CREATE TABLE [dbo].[Usuario_Tarefa] (
    [cd_usuario]           INT          NOT NULL,
    [cd_tarefa]            INT          NOT NULL,
    [dt_tarefa]            DATETIME     NULL,
    [nm_tarefa]            VARCHAR (40) NULL,
    [ds_tarefa]            TEXT         NULL,
    [cd_status_tarefa]     INT          NULL,
    [dt_aviso_tarefa]      DATETIME     NULL,
    [dt_entrega_tarefa]    DATETIME     NULL,
    [ic_ocorrencia_tarefa] CHAR (1)     NULL,
    [cd_ocorrencia]        INT          NULL,
    [dt_inicio_tarefa]     DATETIME     NULL,
    [cd_prioridade_tarefa] INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Usuario_Tarefa] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [cd_tarefa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Tarefa_Prioridade_Tarefa] FOREIGN KEY ([cd_prioridade_tarefa]) REFERENCES [dbo].[Prioridade_Tarefa] ([cd_prioridade_tarefa]),
    CONSTRAINT [FK_Usuario_Tarefa_Status_Tarefa] FOREIGN KEY ([cd_status_tarefa]) REFERENCES [dbo].[Status_Tarefa] ([cd_status_tarefa])
);

