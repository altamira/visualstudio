CREATE TABLE [dbo].[Pedido_Venda_Item_Historico_Custo] (
    [cd_pedido_venda]               INT        NOT NULL,
    [cd_item_pedido_venda]          INT        NOT NULL,
    [dt_apuracao_custo]             DATETIME   NOT NULL,
    [cd_materia_prima]              INT        NOT NULL,
    [cd_metodo_valoracao]           INT        NOT NULL,
    [cd_fase_produto]               INT        NOT NULL,
    [qt_peso_bruto_saldo]           FLOAT (53) NOT NULL,
    [vl_custo_unitario]             FLOAT (53) NULL,
    [vl_custo_total_item_ped_venda] FLOAT (53) NOT NULL,
    [dt_baixa_estoque]              DATETIME   NULL,
    [cd_grupo_produto]              INT        NOT NULL,
    [cd_grupo_inventario]           INT        NULL,
    [vl_preco_lista_pedido]         FLOAT (53) NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_Historico_Custo] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Item_Historico_Custo_Grupo_Inventario] FOREIGN KEY ([cd_grupo_inventario]) REFERENCES [dbo].[Grupo_Inventario] ([cd_grupo_inventario]),
    CONSTRAINT [FK_Pedido_Venda_Item_Historico_Custo_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

