﻿CREATE TABLE [dbo].[Registro_Atividade_Cliente] (
    [cd_registro_atividade]     INT           NOT NULL,
    [dt_registro_atividade]     DATETIME      NOT NULL,
    [cd_cliente]                INT           NULL,
    [cd_contato]                INT           NULL,
    [cd_atividade_analista]     INT           NULL,
    [cd_modulo]                 INT           NULL,
    [cd_atividade_cliente]      INT           NULL,
    [ds_registro_atividade]     TEXT          NULL,
    [dt_inicio_atividade]       DATETIME      NULL,
    [dt_final_atividade]        DATETIME      NULL,
    [qt_hora_atividade]         FLOAT (53)    NULL,
    [cd_consultor]              INT           NULL,
    [dt_conclusao_atividade]    DATETIME      NULL,
    [qt_hora_real_atividade]    FLOAT (53)    NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ic_programacao_atividade]  CHAR (1)      NULL,
    [dt_autorizacao_cliente]    DATETIME      NULL,
    [nm_responsavel_cliente]    VARCHAR (100) NULL,
    [nm_ra]                     VARCHAR (25)  NULL,
    [cd_local_tarefa]           INT           NULL,
    [nm_obs_registro_atividade] VARCHAR (40)  NULL,
    [cd_tarefa_atividade]       INT           NULL,
    [cd_menu]                   INT           NULL,
    [nm_documento_autorizacao]  VARCHAR (100) NULL,
    [cd_consultor_atividade]    INT           NULL,
    [ds_conclusao_atividade]    TEXT          NULL,
    [cd_projeto_sistema]        INT           NULL,
    [cd_tipo_horario]           INT           NULL,
    [ic_visita]                 CHAR (1)      NULL,
    [dt_confirmacao_visita]     DATETIME      NULL,
    [nm_visita_responsavel]     VARCHAR (40)  NULL,
    CONSTRAINT [PK_Registro_Atividade_Cliente] PRIMARY KEY CLUSTERED ([cd_registro_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Atividade_Cliente_Projeto_Sistema] FOREIGN KEY ([cd_projeto_sistema]) REFERENCES [dbo].[Projeto_Sistema] ([cd_projeto_sistema]),
    CONSTRAINT [FK_Registro_Atividade_Cliente_Tarefa_Atividade_Implantacao] FOREIGN KEY ([cd_tarefa_atividade]) REFERENCES [dbo].[Tarefa_Atividade_Implantacao] ([cd_tarefa_atividade]),
    CONSTRAINT [FK_Registro_Atividade_Cliente_Tipo_Horario] FOREIGN KEY ([cd_tipo_horario]) REFERENCES [dbo].[Tipo_Horario] ([cd_tipo_horario])
);

