CREATE TABLE [dbo].[CO_ParcelasPedido] (
    [copa_Pedido]            INT           NOT NULL,
    [copa_NFiscalFornecedor] NVARCHAR (50) NOT NULL,
    [copa_Parcela]           INT           NOT NULL,
    [copa_Dias]              INT           NULL,
    [copa_Vencimento]        SMALLDATETIME NULL,
    [copa_Valor]             MONEY         NULL,
    [copa_Abatimento]        MONEY         NULL,
    [copa_fechado]           REAL          NULL,
    CONSTRAINT [PK_CO_ParcelasPedido] PRIMARY KEY NONCLUSTERED ([copa_Pedido] ASC, [copa_NFiscalFornecedor] ASC, [copa_Parcela] ASC) WITH (FILLFACTOR = 90)
);

