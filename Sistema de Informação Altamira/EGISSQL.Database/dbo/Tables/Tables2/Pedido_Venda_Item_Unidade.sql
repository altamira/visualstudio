CREATE TABLE [dbo].[Pedido_Venda_Item_Unidade] (
    [cd_pedido_venda]       INT          NOT NULL,
    [cd_item_pedido_venda]  INT          NOT NULL,
    [qt_embalagem]          FLOAT (53)   NULL,
    [qt_unidade]            FLOAT (53)   NULL,
    [cd_tipo_embalagem]     INT          NULL,
    [qt_multiplo_embalagem] FLOAT (53)   NULL,
    [nm_obs_unidade]        VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Unidade] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

