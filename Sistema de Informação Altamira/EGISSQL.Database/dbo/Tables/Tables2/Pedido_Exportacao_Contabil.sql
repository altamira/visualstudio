CREATE TABLE [dbo].[Pedido_Exportacao_Contabil] (
    [cd_pedido_venda]      INT          NOT NULL,
    [cd_item_contabil]     INT          NOT NULL,
    [ic_tipo_atualizacao]  CHAR (1)     NULL,
    [vl_contabil_pedido]   FLOAT (53)   NULL,
    [dt_contabil_pedido]   DATETIME     NULL,
    [cd_lancamento_padrao] INT          NULL,
    [nm_compl_historico]   VARCHAR (40) NULL,
    [nm_obs_contabil]      VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Pedido_Exportacao_Contabil] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_contabil] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Exportacao_Contabil_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

