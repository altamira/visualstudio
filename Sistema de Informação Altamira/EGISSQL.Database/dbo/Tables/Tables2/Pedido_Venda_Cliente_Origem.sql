CREATE TABLE [dbo].[Pedido_Venda_Cliente_Origem] (
    [cd_pedido_venda]   INT      NOT NULL,
    [cd_cliente_origem] INT      NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Pedido_Venda_Cliente_Origem] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC) WITH (FILLFACTOR = 90)
);

