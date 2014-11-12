CREATE TABLE [dbo].[Tarefa] (
    [cd_tarefa]          INT          NOT NULL,
    [nm_tarefa]          VARCHAR (40) NOT NULL,
    [dt_tarefa]          DATETIME     NOT NULL,
    [cd_tipo_tarefa]     INT          NOT NULL,
    [cd_status_tarefa]   INT          NOT NULL,
    [cd_tipo_prioridade] INT          NOT NULL,
    [ds_tarefa]          TEXT         NOT NULL,
    [cd_departamento]    INT          NOT NULL,
    [cd_usuario_tarefa]  INT          NOT NULL,
    [pc_execucao_tarefa] FLOAT (53)   NOT NULL,
    [cd_usuario]         INT          NOT NULL,
    [dt_usuario]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Tarefa] PRIMARY KEY CLUSTERED ([cd_tarefa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tarefa_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Tarefa_Status_Tarefa] FOREIGN KEY ([cd_status_tarefa]) REFERENCES [dbo].[Status_Tarefa] ([cd_status_tarefa]),
    CONSTRAINT [FK_Tarefa_Tipo_Prioridade] FOREIGN KEY ([cd_tipo_prioridade]) REFERENCES [dbo].[Tipo_Prioridade] ([cd_tipo_prioridade]),
    CONSTRAINT [FK_Tarefa_Tipo_Tarefa] FOREIGN KEY ([cd_tipo_tarefa]) REFERENCES [dbo].[Tipo_Tarefa] ([cd_tipo_tarefa])
);

