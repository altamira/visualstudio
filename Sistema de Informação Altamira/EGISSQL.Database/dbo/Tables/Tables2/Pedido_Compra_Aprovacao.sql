CREATE TABLE [dbo].[Pedido_Compra_Aprovacao] (
    [cd_pedido_compra]         INT      NOT NULL,
    [cd_tipo_aprovacao]        INT      NOT NULL,
    [cd_usuario_aprovacao]     INT      NULL,
    [dt_usuario_aprovacao]     DATETIME NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [cd_item_aprovacao_pedido] INT      NULL,
    CONSTRAINT [PK_Pedido_Compra_Aprovacao] PRIMARY KEY CLUSTERED ([cd_pedido_compra] ASC, [cd_tipo_aprovacao] ASC) WITH (FILLFACTOR = 90)
);

