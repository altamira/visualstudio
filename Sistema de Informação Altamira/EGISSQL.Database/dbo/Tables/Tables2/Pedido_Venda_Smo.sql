CREATE TABLE [dbo].[Pedido_Venda_Smo] (
    [cd_pedido_venda_smo]      INT          NULL,
    [cd_pedido_venda]          INT          NULL,
    [cd_nota_smo_pedido_venda] INT          NULL,
    [cd_item_nota_smo_pedido]  INT          NULL,
    [dt_nota_smo_pedido_venda] DATETIME     NULL,
    [nm_obs_nota_smo_pedido]   VARCHAR (50) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [FK_Pedido_Venda_Smo_Pedido_Venda] FOREIGN KEY ([cd_pedido_venda]) REFERENCES [dbo].[Pedido_Venda] ([cd_pedido_venda]) NOT FOR REPLICATION
);

