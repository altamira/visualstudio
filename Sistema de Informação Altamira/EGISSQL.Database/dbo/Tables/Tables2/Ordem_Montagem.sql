CREATE TABLE [dbo].[Ordem_Montagem] (
    [cd_ordem_montagem]    INT      NULL,
    [dt_ordem_montagem]    DATETIME NULL,
    [ds_ordem_montagem]    TEXT     NULL,
    [cd_pedido_venda]      INT      NULL,
    [cd_item_pedido_venda] INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL
);

