CREATE TABLE [dbo].[Produto_Consignacao] (
    [cd_produto]              INT          NOT NULL,
    [cd_fase_produto]         INT          NOT NULL,
    [qt_produto_consignacao]  FLOAT (53)   NULL,
    [cd_fornecedor]           INT          NULL,
    [nm_obs_prod_consignacao] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Produto_Consignacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_fase_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Consignacao_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

