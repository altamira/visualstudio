CREATE TABLE [dbo].[Plano_Financeiro_Lote] (
    [cd_lote_plano_financeiro] INT          NOT NULL,
    [dt_lote_plano_financeiro] DATETIME     NOT NULL,
    [vl_lote_plano_financeiro] FLOAT (53)   NOT NULL,
    [qt_parcela]               FLOAT (53)   NOT NULL,
    [dt_vencimento]            DATETIME     NOT NULL,
    [qt_dia_intervalo]         FLOAT (53)   NOT NULL,
    [pc_juros]                 FLOAT (53)   NOT NULL,
    [nm_historico]             VARCHAR (20) NOT NULL,
    [cd_tipo_lancamento_fluxo] INT          NOT NULL,
    [cd_historico_financeiro]  INT          NOT NULL,
    [cd_plano_financeiro]      INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usaurio]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Plano_Financeiro_Lote] PRIMARY KEY CLUSTERED ([cd_lote_plano_financeiro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Plano_Financeiro_Lote_Historico_Financeiro] FOREIGN KEY ([cd_historico_financeiro]) REFERENCES [dbo].[Historico_Financeiro] ([cd_historico_financeiro]),
    CONSTRAINT [FK_Plano_Financeiro_Lote_Tipo_Lancamento_Fluxo] FOREIGN KEY ([cd_tipo_lancamento_fluxo]) REFERENCES [dbo].[Tipo_Lancamento_Fluxo] ([cd_tipo_lancamento_fluxo])
);

