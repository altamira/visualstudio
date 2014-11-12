CREATE TABLE [dbo].[Cliente_Serie_Produto_Desconto] (
    [cd_cliente]                INT        NOT NULL,
    [cd_serie_produto]          INT        NOT NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [pc_desconto_cliente_serie] FLOAT (53) NULL,
    CONSTRAINT [PK_Cliente_Serie_Produto_Desconto] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_serie_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Serie_Produto_Desconto_Serie_Produto] FOREIGN KEY ([cd_serie_produto]) REFERENCES [dbo].[Serie_Produto] ([cd_serie_produto])
);

