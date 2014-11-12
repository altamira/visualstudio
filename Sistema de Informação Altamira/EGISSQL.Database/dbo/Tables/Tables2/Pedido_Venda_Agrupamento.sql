CREATE TABLE [dbo].[Pedido_Venda_Agrupamento] (
    [dt_usuario]               DATETIME     NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [nm_obs_ped_venda_agrupa]  VARCHAR (40) NOT NULL,
    [cd_item_pedido_venda]     INT          NOT NULL,
    [cd_pedido_venda_agrupa]   INT          NOT NULL,
    [cd_item_agrupa_ped_venda] INT          NOT NULL,
    [cd_pedido_venda]          INT          NOT NULL,
    CONSTRAINT [PK_Pedido_Venda_Agrupamento] PRIMARY KEY CLUSTERED ([cd_item_pedido_venda] ASC, [cd_pedido_venda_agrupa] ASC, [cd_item_agrupa_ped_venda] ASC, [cd_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

