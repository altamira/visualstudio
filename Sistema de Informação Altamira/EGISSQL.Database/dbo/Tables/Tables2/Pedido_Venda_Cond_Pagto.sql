CREATE TABLE [dbo].[Pedido_Venda_Cond_Pagto] (
    [cd_pedido_venda]         INT          NULL,
    [cd_item_pedido_venda]    INT          NULL,
    [qt_parcela_pedido_venda] INT          NULL,
    [pc_parcela_pedido_venda] FLOAT (53)   NULL,
    [vl_parcela_pedido_venda] FLOAT (53)   NULL,
    [dt_parcela_pedido_venda] DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_parcela_pedido_venda] VARCHAR (40) NULL,
    [sg_parcela_pedido_venda] CHAR (10)    NULL
);

