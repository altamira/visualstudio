CREATE TABLE [dbo].[CO_ItemNota] (
    [coin_Nota]          CHAR (6)        NOT NULL,
    [coin_TipoPedido]    CHAR (1)        NOT NULL,
    [coin_Numero]        INT             NOT NULL,
    [coin_Item]          INT             NOT NULL,
    [coin_Quantidade]    DECIMAL (18, 3) NOT NULL,
    [coin_Valor]         MONEY           NOT NULL,
    [coin_DataNota]      SMALLDATETIME   NOT NULL,
    [coin_DataEntrada]   SMALLDATETIME   NOT NULL,
    [coin_Credito]       CHAR (1)        NOT NULL,
    [coin_AliqICMS]      FLOAT (53)      NULL,
    [coin_AliqIPI]       FLOAT (53)      NULL,
    [coin_CFOP]          CHAR (10)       NULL,
    [coin_ValorProdutos] MONEY           NULL,
    [coin_Lock]          BINARY (8)      NULL
);

