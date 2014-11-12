CREATE TABLE [dbo].[Ficha_Medida] (
    [cd_ficha_medida]           INT      NULL,
    [dt_ficha_medida]           DATETIME NULL,
    [ds_ficha_medida]           TEXT     NULL,
    [cd_pedido_venda]           INT      NULL,
    [cd_item_pedido_venda]      INT      NULL,
    [cd_requisicao_compra]      INT      NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [dt_liberacao_ficha_medida] DATETIME NULL
);

