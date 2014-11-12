CREATE TABLE [dbo].[Estoque_Pedido_Venda] (
    [cd_estoque_pedido]    INT        NOT NULL,
    [cd_pedido_venda]      INT        NULL,
    [cd_item_pedido_venda] INT        NULL,
    [qt_estoque]           FLOAT (53) NULL,
    [cd_produto]           INT        NULL,
    [dt_estoque]           DATETIME   NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    CONSTRAINT [PK_Estoque_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_estoque_pedido] ASC) WITH (FILLFACTOR = 90)
);

