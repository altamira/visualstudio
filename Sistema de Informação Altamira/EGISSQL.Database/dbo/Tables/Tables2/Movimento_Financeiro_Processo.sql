CREATE TABLE [dbo].[Movimento_Financeiro_Processo] (
    [cd_movimento]             INT          NOT NULL,
    [dt_movimento]             DATETIME     NULL,
    [cd_processo_juridico]     INT          NULL,
    [cd_tipo_despesa]          INT          NULL,
    [vl_movimento]             FLOAT (53)   NULL,
    [cd_historico_financeiro]  INT          NULL,
    [nm_complemento_movimento] VARCHAR (40) NULL,
    [ic_tipo_movimento]        CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Movimento_Financeiro_Processo] PRIMARY KEY CLUSTERED ([cd_movimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Financeiro_Processo_Historico_Financeiro] FOREIGN KEY ([cd_historico_financeiro]) REFERENCES [dbo].[Historico_Financeiro] ([cd_historico_financeiro])
);

