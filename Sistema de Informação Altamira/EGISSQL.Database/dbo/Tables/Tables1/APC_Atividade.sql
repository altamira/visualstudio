CREATE TABLE [dbo].[APC_Atividade] (
    [cd_atividade]            INT          NOT NULL,
    [dt_atividade]            DATETIME     NULL,
    [nm_atividade]            VARCHAR (60) NULL,
    [ds_atividade]            TEXT         NULL,
    [cd_assunto]              INT          NULL,
    [dt_inicio_atividade]     DATETIME     NULL,
    [qt_dia_atividade]        INT          NULL,
    [dt_final_atividade]      DATETIME     NULL,
    [dt_conclusao]            DATETIME     NULL,
    [pc_atividade]            FLOAT (53)   NULL,
    [cd_status_atividade]     INT          NOT NULL,
    [cd_funcionario]          INT          NULL,
    [cd_prioridade_atividade] INT          NULL,
    [nm_obs_atividade]        VARCHAR (60) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_APC_Atividade] PRIMARY KEY CLUSTERED ([cd_atividade] ASC),
    CONSTRAINT [FK_APC_Atividade_APC_Prioridade_Atividade] FOREIGN KEY ([cd_prioridade_atividade]) REFERENCES [dbo].[APC_Prioridade_Atividade] ([cd_prioridade_atividade])
);

