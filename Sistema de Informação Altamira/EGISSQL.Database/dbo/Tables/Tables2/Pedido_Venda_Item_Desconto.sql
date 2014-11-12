CREATE TABLE [dbo].[Pedido_Venda_Item_Desconto] (
    [cd_pedido_venda]         INT        NOT NULL,
    [cd_item_pedido_venda]    INT        NOT NULL,
    [cd_item_pedido_desconto] INT        NOT NULL,
    [pc_desc_ad_item_pedido]  FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Desconto] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC, [cd_item_pedido_desconto] ASC) WITH (FILLFACTOR = 90)
);

