CREATE TABLE [dbo].[Produto_Venda_Tipo_Pedido] (
    [cd_produto]     INT        NOT NULL,
    [cd_tipo_pedido] INT        NOT NULL,
    [vl_produto]     FLOAT (53) NULL,
    [cd_usuario]     INT        NULL,
    [dt_usuario]     DATETIME   NULL,
    CONSTRAINT [PK_Produto_Venda_Tipo_Pedido] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_tipo_pedido] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Venda_Tipo_Pedido_Tipo_Pedido] FOREIGN KEY ([cd_tipo_pedido]) REFERENCES [dbo].[Tipo_Pedido] ([cd_tipo_pedido])
);

