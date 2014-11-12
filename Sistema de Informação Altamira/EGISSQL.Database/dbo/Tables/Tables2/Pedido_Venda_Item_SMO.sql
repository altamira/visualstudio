CREATE TABLE [dbo].[Pedido_Venda_Item_SMO] (
    [cd_pedido_venda]      INT          NOT NULL,
    [cd_item_pedido_venda] INT          NOT NULL,
    [cd_grupo_produto]     INT          NULL,
    [cd_categoria_produto] INT          NULL,
    [nm_produto_item_smo]  VARCHAR (50) NULL,
    [cd_unidade_medida]    INT          NULL,
    [pc_ipi]               FLOAT (53)   NULL,
    [pc_icms]              FLOAT (53)   NULL,
    [ds_produto_item_smo]  TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_servico]           INT          NULL,
    CONSTRAINT [PK_Pedido_Venda_Item_SMO] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

