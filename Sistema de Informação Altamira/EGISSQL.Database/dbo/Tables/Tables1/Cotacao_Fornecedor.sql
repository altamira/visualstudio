CREATE TABLE [dbo].[Cotacao_Fornecedor] (
    [cd_cotacao]    INT      NOT NULL,
    [cd_fornecedor] INT      NOT NULL,
    [cd_usuario]    INT      NULL,
    [dt_usuario]    DATETIME NULL,
    CONSTRAINT [PK_Cotacao_Fornecedor] PRIMARY KEY CLUSTERED ([cd_cotacao] ASC, [cd_fornecedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cotacao_Fornecedor_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

