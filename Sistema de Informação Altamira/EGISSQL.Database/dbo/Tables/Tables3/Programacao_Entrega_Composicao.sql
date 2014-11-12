CREATE TABLE [dbo].[Programacao_Entrega_Composicao] (
    [cd_programacao_entrega]      INT          NOT NULL,
    [cd_item_programacao]         INT          NOT NULL,
    [cd_produto]                  INT          NOT NULL,
    [qt_item_programacao]         FLOAT (53)   NULL,
    [qt_saldo_item_programacao]   FLOAT (53)   NULL,
    [dt_entrega_item_programacao] DATETIME     NULL,
    [cd_lote_item_programacao]    VARCHAR (25) NULL,
    [cd_item_pdc_programacao]     INT          NULL,
    [nm_obs_item_programacao]     VARCHAR (40) NULL,
    [cd_pedido_venda]             INT          NULL,
    [cd_item_pedido_venda]        INT          NULL,
    [cd_previa_faturamento]       INT          NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_processo]                 INT          NULL,
    [cd_movimento_estoque]        INT          NULL,
    CONSTRAINT [PK_Programacao_Entrega_Composicao] PRIMARY KEY CLUSTERED ([cd_programacao_entrega] ASC, [cd_item_programacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Entrega_Composicao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

