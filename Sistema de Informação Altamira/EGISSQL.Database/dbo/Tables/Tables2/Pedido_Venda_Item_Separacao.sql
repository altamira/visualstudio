CREATE TABLE [dbo].[Pedido_Venda_Item_Separacao] (
    [cd_pedido_venda]              INT           NOT NULL,
    [cd_item_pedido_venda]         INT           NOT NULL,
    [cd_produto]                   INT           NOT NULL,
    [qt_item_estrutura_separada]   FLOAT (53)    NULL,
    [qt_item_estrutura_entrada]    FLOAT (53)    NULL,
    [cd_movimento_estoque]         INT           NULL,
    [nm_descritivo_separacao]      VARCHAR (100) NULL,
    [cd_movimento_estoque_entrada] INT           NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Separacao] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90)
);

