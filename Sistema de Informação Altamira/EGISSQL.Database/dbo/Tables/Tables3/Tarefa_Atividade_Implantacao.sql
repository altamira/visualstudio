CREATE TABLE [dbo].[Tarefa_Atividade_Implantacao] (
    [cd_tarefa_atividade]       INT           NOT NULL,
    [cd_atividade]              INT           NOT NULL,
    [nm_tarefa_atividade]       VARCHAR (50)  NULL,
    [ds_tarefa_atividade]       TEXT          NULL,
    [qt_tarefa_atividade]       FLOAT (53)    NULL,
    [cd_ordem_tarefa_atividade] INT           NULL,
    [nm_obs_tarefa_atividade]   VARCHAR (40)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_documento_tarefa]       VARCHAR (100) NULL,
    CONSTRAINT [PK_Tarefa_Atividade_Implantacao] PRIMARY KEY CLUSTERED ([cd_tarefa_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tarefa_Atividade_Implantacao_Atividade_Implantacao] FOREIGN KEY ([cd_atividade]) REFERENCES [dbo].[Atividade_Implantacao] ([cd_atividade])
);

