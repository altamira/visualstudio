CREATE TABLE [dbo].[Historico_Compra_Produto] (
    [cd_historico_compra]        INT           NOT NULL,
    [dt_historico_compra]        DATETIME      NULL,
    [cd_produto]                 INT           NULL,
    [cd_fornecedor]              INT           NULL,
    [cd_cotacao]                 INT           NULL,
    [dt_cotacao]                 DATETIME      NULL,
    [vl_historico_compra]        FLOAT (53)    NULL,
    [pc_ipi]                     FLOAT (53)    NULL,
    [pc_icms]                    FLOAT (53)    NULL,
    [pc_desconto]                FLOAT (53)    NULL,
    [vl_liq_historico_compra]    FLOAT (53)    NULL,
    [nm_historico_compra]        VARCHAR (100) NULL,
    [cd_condicao_pagamento]      INT           NULL,
    [qt_dia_entrega]             FLOAT (53)    NULL,
    [nm_entrega]                 VARCHAR (40)  NULL,
    [cd_pedido_compra]           INT           NULL,
    [cd_requisicao_compra]       INT           NULL,
    [cd_item_requisicao_compra]  INT           NULL,
    [cd_opcao_compra]            INT           NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [qt_historico_compra]        FLOAT (53)    NULL,
    [cd_item_pedido_compra]      INT           NULL,
    [cd_item_cotacao]            INT           NULL,
    [nm_marca_produto]           VARCHAR (30)  NULL,
    [dt_pedido_compra]           DATETIME      NULL,
    [dt_requisicao_compra]       DATETIME      NULL,
    [cd_nota_entrada]            INT           NULL,
    [cd_item_nota_entrada]       INT           NULL,
    [dt_nota_entrada]            DATETIME      NULL,
    [cd_local_entrega_empresa]   INT           NULL,
    [ic_manual_hist_compra]      CHAR (1)      NULL,
    [qt_pesliq_compra_produto]   FLOAT (53)    NULL,
    [qt_pesbruto_compra_produto] FLOAT (53)    NULL,
    [ds_historico_compra]        TEXT          NULL,
    [cd_servico]                 INT           NULL,
    [cd_moeda]                   INT           NULL,
    CONSTRAINT [PK_Historico_Compra_Produto] PRIMARY KEY CLUSTERED ([cd_historico_compra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Historico_Compra_Produto_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);


GO
CREATE NONCLUSTERED INDEX [IX_Historico_Compra_Produto_cotacao]
    ON [dbo].[Historico_Compra_Produto]([cd_cotacao] ASC, [cd_item_cotacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Historico_Compra_Produto_Pedido]
    ON [dbo].[Historico_Compra_Produto]([cd_pedido_compra] ASC, [cd_item_cotacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Historico_Compra_Produto_Nota]
    ON [dbo].[Historico_Compra_Produto]([cd_nota_entrada] ASC, [cd_item_nota_entrada] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Historico_Compra_Produto_Requisicao]
    ON [dbo].[Historico_Compra_Produto]([cd_requisicao_compra] ASC, [cd_opcao_compra] ASC) WITH (FILLFACTOR = 90);

