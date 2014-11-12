CREATE TABLE [dbo].[Fornecedor_Produto_Preco] (
    [cd_fornecedor]         INT          NOT NULL,
    [cd_produto]            INT          NOT NULL,
    [cd_moeda]              INT          NOT NULL,
    [cd_item_produto_moeda] INT          NOT NULL,
    [vl_produto_moeda]      FLOAT (53)   NULL,
    [dt_produto_moeda]      DATETIME     NULL,
    [nm_obs_produto_moeda]  VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Produto_Preco] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_produto] ASC, [cd_moeda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Produto_Preco_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

