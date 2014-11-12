CREATE TABLE [dbo].[Pedido_Compra_Historico] (
    [cd_item_pedido_compra]        INT           NOT NULL,
    [cd_pedido_compra]             INT           NOT NULL,
    [cd_pedido_compra_histor]      INT           NOT NULL,
    [dt_pedido_compra]             DATETIME      NULL,
    [nm_pedido_compra_histor_1]    VARCHAR (100) NULL,
    [nm_pedido_compra_histor_2]    VARCHAR (100) NULL,
    [nm_pedido_compra_histor_3]    VARCHAR (100) NULL,
    [cd_departamento]              INT           NULL,
    [cd_tipo_status_pedido]        INT           NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    [nm_pedido_compra_historico_3] VARCHAR (100) NULL,
    CONSTRAINT [PK_Pedido_Compra_Historico] PRIMARY KEY CLUSTERED ([cd_item_pedido_compra] ASC, [cd_pedido_compra] ASC, [cd_pedido_compra_histor] ASC) WITH (FILLFACTOR = 90)
);

