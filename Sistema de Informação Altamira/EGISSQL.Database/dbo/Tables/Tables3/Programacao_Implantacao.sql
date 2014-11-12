CREATE TABLE [dbo].[Programacao_Implantacao] (
    [cd_programacao]       INT        NOT NULL,
    [dt_programacao]       DATETIME   NULL,
    [cd_cliente]           INT        NULL,
    [cd_modulo]            INT        NULL,
    [cd_atividade]         INT        NULL,
    [cd_consultor]         INT        NULL,
    [qt_hora_programacao]  FLOAT (53) NULL,
    [dt_inicial_atividade] DATETIME   NULL,
    [dt_final_atividade]   DATETIME   NULL,
    [dt_baixa_atividade]   DATETIME   NULL,
    [ds_programacao]       TEXT       NULL,
    [cd_atividade_cliente] INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    CONSTRAINT [PK_Programacao_Implantacao] PRIMARY KEY CLUSTERED ([cd_programacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Implantacao_Atividade_Cliente] FOREIGN KEY ([cd_atividade_cliente]) REFERENCES [dbo].[Atividade_Cliente] ([cd_atividade_cliente])
);

