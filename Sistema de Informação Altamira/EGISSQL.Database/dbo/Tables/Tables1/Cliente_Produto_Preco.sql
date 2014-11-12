CREATE TABLE [dbo].[Cliente_Produto_Preco] (
    [cd_cliente]         INT        NOT NULL,
    [cd_produto]         INT        NOT NULL,
    [cd_moeda]           INT        NULL,
    [vl_cliente_produto] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Cliente_Produto_Preco] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Produto_Preco_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

