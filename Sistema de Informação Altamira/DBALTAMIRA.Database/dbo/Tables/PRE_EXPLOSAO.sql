CREATE TABLE [dbo].[PRE_EXPLOSAO] (
    [prex_CodProduto] VARCHAR (30) NOT NULL,
    [prex_Sequencia]  INT          NOT NULL,
    [prex_Descricao]  VARCHAR (50) NULL,
    [prex_Qtde]       INT          NULL,
    CONSTRAINT [PK_PRE_EXPLOSAO] PRIMARY KEY NONCLUSTERED ([prex_CodProduto] ASC, [prex_Sequencia] ASC) WITH (FILLFACTOR = 90)
);

