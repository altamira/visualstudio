CREATE TABLE [dbo].[Pedido_Venda_Item_Lote] (
    [cd_pedido_venda]      INT        NOT NULL,
    [cd_item_pedido_venda] INT        NOT NULL,
    [cd_lote_produto]      INT        NOT NULL,
    [qt_selecionado_lote]  FLOAT (53) NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_usuario]           INT        NULL,
    [ic_reserva_lote]      CHAR (1)   NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Lote] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC, [cd_lote_produto] ASC) WITH (FILLFACTOR = 90)
);

