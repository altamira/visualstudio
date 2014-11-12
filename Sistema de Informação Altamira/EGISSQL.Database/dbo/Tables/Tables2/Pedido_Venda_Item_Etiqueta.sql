CREATE TABLE [dbo].[Pedido_Venda_Item_Etiqueta] (
    [cd_pedido_venda]      INT          NULL,
    [cd_item_pedido_venda] INT          NULL,
    [qt_item_etiqueta]     FLOAT (53)   NULL,
    [qt_peso_liquido]      FLOAT (53)   NULL,
    [qt_peso_bruto]        FLOAT (53)   NULL,
    [cd_usuario_embalagem] INT          NULL,
    [dt_etiqueta]          DATETIME     NULL,
    [qt_numero]            FLOAT (53)   NULL,
    [qt_volume]            FLOAT (53)   NULL,
    [nm_obs_etiqueta]      VARCHAR (50) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_ordem_etiqueta]    INT          NULL
);

