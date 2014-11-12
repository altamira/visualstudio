CREATE TABLE [dbo].[Pedido_Venda_Item_Grade] (
    [cd_pedido_venda]           INT        NOT NULL,
    [cd_item_pedido_venda]      INT        NOT NULL,
    [cd_cor]                    INT        NULL,
    [cd_ambiente]               INT        NULL,
    [qt_larg_item_pedido_venda] FLOAT (53) NULL,
    [qt_alt_item_pedido_venda]  FLOAT (53) NULL,
    [cd_produto_grade]          INT        NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [pc_acresc_cor]             FLOAT (53) NULL,
    [cd_tipo_grade]             INT        NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Grade] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Item_Grade_Tipo_Grade] FOREIGN KEY ([cd_tipo_grade]) REFERENCES [dbo].[Tipo_Grade] ([cd_tipo_grade])
);

