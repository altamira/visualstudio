CREATE TABLE [dbo].[Solicitacao_Pagamento_Composicao] (
    [cd_solicitacao]            INT          NOT NULL,
    [cd_item_solicitacao]       INT          NOT NULL,
    [cd_tipo_despesa]           INT          NULL,
    [cd_conta]                  INT          NULL,
    [cd_centro_custo]           INT          NULL,
    [cd_planta]                 INT          NULL,
    [vl_item_solicitacao]       FLOAT (53)   NULL,
    [cd_historico_financeiro]   INT          NULL,
    [cd_historico_contabil]     INT          NULL,
    [cd_lancamento_contabil]    INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [nm_complemento_historico]  VARCHAR (40) NULL,
    [qt_item_solicitacao]       FLOAT (53)   NULL,
    [pc_item_solicitacao]       FLOAT (53)   NULL,
    [vl_total_item_solicitacao] FLOAT (53)   NULL,
    [cd_projeto_viagem]         INT          NULL,
    [nm_projeto_viagem]         VARCHAR (40) NULL,
    CONSTRAINT [PK_Solicitacao_Pagamento_Composicao] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC, [cd_item_solicitacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Solicitacao_Pagamento_Composicao_Historico_Contabil] FOREIGN KEY ([cd_historico_contabil]) REFERENCES [dbo].[Historico_Contabil] ([cd_historico_contabil]),
    CONSTRAINT [FK_Solicitacao_Pagamento_Composicao_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_contabil]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

