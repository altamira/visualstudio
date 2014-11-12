CREATE TABLE [dbo].[Produto_Preco_Venda] (
    [cd_produto]             INT          NOT NULL,
    [cd_moeda]               INT          NOT NULL,
    [vl_moeda_venda_produto] FLOAT (53)   NULL,
    [nm_obs_venda_produto]   VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Produto_Preco_Venda] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_moeda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Preco_Venda_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

