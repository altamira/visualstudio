CREATE TABLE [dbo].[Pedido_Compra_Follow] (
    [cd_pedido_compra]         INT           NOT NULL,
    [cd_item_follow_pedido]    INT           NOT NULL,
    [dt_follow_pedido]         DATETIME      NULL,
    [nm_contato_follow_pedido] VARCHAR (40)  NULL,
    [nm_motivo_follow_pedido]  VARCHAR (30)  NULL,
    [nm_hist_follow_pedido]    VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [nm_compl_follow_pedido]   VARCHAR (100) NULL,
    CONSTRAINT [PK_Pedido_Compra_Follow] PRIMARY KEY CLUSTERED ([cd_pedido_compra] ASC, [cd_item_follow_pedido] ASC) WITH (FILLFACTOR = 90)
);

