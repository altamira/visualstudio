CREATE TABLE [dbo].[Atividade_Implantacao] (
    [cd_atividade]           INT           NOT NULL,
    [nm_atividade]           VARCHAR (60)  NOT NULL,
    [ds_atividade]           TEXT          NULL,
    [qt_hora_atividade]      FLOAT (53)    NULL,
    [ic_execucao_atividade]  CHAR (1)      NULL,
    [nm_obs_atividade]       VARCHAR (40)  NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [cd_grupo_atividade]     INT           NULL,
    [qt_ordem_atividade]     INT           NULL,
    [cd_local_tarefa]        INT           NULL,
    [cd_departamento]        INT           NULL,
    [nm_documento_atividade] VARCHAR (100) NULL,
    CONSTRAINT [PK_Atividade_Implantacao] PRIMARY KEY CLUSTERED ([cd_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atividade_Implantacao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Atividade_Implantacao_Grupo_Atividade_Implantacao] FOREIGN KEY ([cd_grupo_atividade]) REFERENCES [dbo].[Grupo_Atividade_Implantacao] ([cd_grupo_atividade]),
    CONSTRAINT [FK_Atividade_Implantacao_Local_Tarefa] FOREIGN KEY ([cd_local_tarefa]) REFERENCES [dbo].[Local_Tarefa] ([cd_local_tarefa])
);

