CREATE TABLE [dbo].[Pedido_Venda_Item_Acessorio] (
    [cd_pedido_venda]        INT        NOT NULL,
    [cd_item_pedido_venda]   INT        NOT NULL,
    [cd_it_acessorio_pedido] INT        NOT NULL,
    [cd_acessorio]           INT        NULL,
    [qt_it_acessorio_pedido] FLOAT (53) NULL,
    [vl_it_acessorio_pedido] FLOAT (53) NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Acessorio] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC, [cd_it_acessorio_pedido] ASC) WITH (FILLFACTOR = 90)
);

