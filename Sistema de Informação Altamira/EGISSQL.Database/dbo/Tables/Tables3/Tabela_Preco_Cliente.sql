CREATE TABLE [dbo].[Tabela_Preco_Cliente] (
    [cd_tabela_preco] INT      NOT NULL,
    [cd_cliente]      INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Tabela_Preco_Cliente] PRIMARY KEY CLUSTERED ([cd_tabela_preco] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tabela_Preco_Cliente_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

