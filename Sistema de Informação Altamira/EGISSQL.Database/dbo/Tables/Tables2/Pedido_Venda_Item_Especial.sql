CREATE TABLE [dbo].[Pedido_Venda_Item_Especial] (
    [cd_item_pedido_venda]    INT          NULL,
    [cd_pedido_venda]         INT          NULL,
    [nm_produto_pedido_venda] VARCHAR (50) NULL,
    [cd_grupo_produto]        INT          NULL,
    [cd_sub_grupo_produto]    INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL
);

