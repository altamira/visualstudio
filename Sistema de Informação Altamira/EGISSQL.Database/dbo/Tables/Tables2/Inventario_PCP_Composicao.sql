CREATE TABLE [dbo].[Inventario_PCP_Composicao] (
    [cd_inventario_pcp]      INT          NOT NULL,
    [cd_item_inventario_pcp] INT          NOT NULL,
    [cd_fase_produto]        INT          NULL,
    [cd_pedido_venda]        INT          NULL,
    [cd_item_pedido_venda]   INT          NULL,
    [qt_item_inventario_pcp] FLOAT (53)   NULL,
    [nm_obs_item_invent_pcp] VARCHAR (40) NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Inventario_PCP_Composicao] PRIMARY KEY CLUSTERED ([cd_inventario_pcp] ASC, [cd_item_inventario_pcp] ASC) WITH (FILLFACTOR = 90)
);

