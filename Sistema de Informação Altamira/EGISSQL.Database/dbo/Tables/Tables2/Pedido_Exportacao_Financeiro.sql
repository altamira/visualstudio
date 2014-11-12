CREATE TABLE [dbo].[Pedido_Exportacao_Financeiro] (
    [cd_pedido_venda]          INT          NOT NULL,
    [cd_item_financeiro]       INT          NOT NULL,
    [ic_tipo_atualizacao]      CHAR (1)     NULL,
    [vl_financeiro_pedido]     FLOAT (53)   NULL,
    [dt_financeiro_pedido]     DATETIME     NULL,
    [cd_plano_financeiro]      INT          NULL,
    [ic_conversao_moeda]       CHAR (1)     NULL,
    [dt_conversao_moeda]       DATETIME     NULL,
    [cd_moeda]                 INT          NULL,
    [cd_historico_financeiro]  INT          NULL,
    [nm_compl_historico]       VARCHAR (40) NULL,
    [nm_obs_pedido_financeiro] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Pedido_Exportacao_Financeiro] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_financeiro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Exportacao_Financeiro_Historico_Financeiro] FOREIGN KEY ([cd_historico_financeiro]) REFERENCES [dbo].[Historico_Financeiro] ([cd_historico_financeiro])
);

