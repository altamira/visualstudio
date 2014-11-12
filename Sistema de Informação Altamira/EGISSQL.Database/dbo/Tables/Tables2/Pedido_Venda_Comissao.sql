CREATE TABLE [dbo].[Pedido_Venda_Comissao] (
    [cd_pedido_venda]          INT          NOT NULL,
    [cd_item_comissao_pedido]  INT          NOT NULL,
    [cd_vendedor]              INT          NULL,
    [cd_vendedor_interno]      INT          NULL,
    [pc_comissao_pedido_venda] FLOAT (53)   NULL,
    [nm_obs_comissao_pedido]   VARCHAR (40) NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    CONSTRAINT [PK_Pedido_Venda_Comissao] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_item_comissao_pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pedido_Venda_Comissao_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

