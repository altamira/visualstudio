CREATE TABLE [dbo].[Processo_Juridico_Financeiro] (
    [cd_processo_juridico]    INT        NOT NULL,
    [vl_causa_processo]       FLOAT (53) NULL,
    [vl_realizido_processo]   FLOAT (53) NULL,
    [vl_atualizacao_processo] FLOAT (53) NULL,
    [ds_processo_financeiro]  TEXT       NULL,
    [dt_causa_processo]       DATETIME   NULL,
    [dt_realizado_processo]   DATETIME   NULL,
    [dt_atualizacao_processo] DATETIME   NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Processo_Juridico_Financeiro] PRIMARY KEY CLUSTERED ([cd_processo_juridico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Financeiro_Processo_Juridico] FOREIGN KEY ([cd_processo_juridico]) REFERENCES [dbo].[Processo_Juridico] ([cd_processo_juridico])
);

