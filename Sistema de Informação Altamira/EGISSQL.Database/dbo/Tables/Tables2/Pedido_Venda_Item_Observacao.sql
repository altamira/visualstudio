CREATE TABLE [dbo].[Pedido_Venda_Item_Observacao] (
    [cd_pedido_venda]      INT        NOT NULL,
    [cd_item_pedido_venda] INT        NOT NULL,
    [cd_pedido_item_obs]   INT        NOT NULL,
    [dt_item_observacao]   DATETIME   NOT NULL,
    [ds_produto_item_obs]  TEXT       NOT NULL,
    [vl_lista_item_obs]    FLOAT (53) NOT NULL,
    [vl_unitario_item_obs] FLOAT (53) NOT NULL,
    [cd_usuario]           INT        NOT NULL,
    [dt_usuario]           DATETIME   NOT NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Observacao] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC, [cd_pedido_item_obs] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Item_Observacao_Pedido_Venda_Item] FOREIGN KEY ([cd_pedido_venda], [cd_item_pedido_venda]) REFERENCES [dbo].[Pedido_Venda_Item] ([cd_pedido_venda], [cd_item_pedido_venda]) NOT FOR REPLICATION
);

