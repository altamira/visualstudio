CREATE TABLE [dbo].[Relatorio_Produto_Check] (
    [cd_produto_check] INT          NOT NULL,
    [dt_produto_check] DATETIME     NULL,
    [cd_vendedor]      INT          NULL,
    [cd_cliente]       INT          NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [nm_produto_check] VARCHAR (40) NULL,
    CONSTRAINT [FK_Relatorio_Produto_Check_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Relatorio_Produto_Check_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

