CREATE TABLE [dbo].[Estrutura_Venda_Comissao] (
    [cd_estrutura_venda]    INT      NOT NULL,
    [cd_item_comissao]      INT      NOT NULL,
    [cd_estrutura_comissao] INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Estrutura_Venda_Comissao] PRIMARY KEY CLUSTERED ([cd_estrutura_venda] ASC, [cd_item_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Estrutura_Venda_Comissao_Estrutura_Venda] FOREIGN KEY ([cd_estrutura_comissao]) REFERENCES [dbo].[Estrutura_Venda] ([cd_estrutura_venda])
);

