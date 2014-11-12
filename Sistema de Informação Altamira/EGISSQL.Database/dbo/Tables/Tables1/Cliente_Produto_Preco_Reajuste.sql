CREATE TABLE [dbo].[Cliente_Produto_Preco_Reajuste] (
    [cd_cliente]                  INT        NOT NULL,
    [cd_produto]                  INT        NOT NULL,
    [dt_reajuste_produto_cliente] DATETIME   NOT NULL,
    [vl_produto_cliente]          FLOAT (53) NULL,
    [cd_usuario]                  INT        NULL,
    [dt_usuario]                  DATETIME   NULL,
    CONSTRAINT [PK_Cliente_Produto_Preco_Reajuste] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_produto] ASC, [dt_reajuste_produto_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Produto_Preco_Reajuste_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

