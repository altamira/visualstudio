CREATE TABLE [dbo].[TabVendedorAux] (
    [Pedido]        REAL          NOT NULL,
    [NotaFiscal]    VARCHAR (50)  NOT NULL,
    [Cliente]       VARCHAR (50)  NULL,
    [Parcela]       SMALLINT      NOT NULL,
    [Vencimento]    SMALLDATETIME NOT NULL,
    [Pagamento]     SMALLDATETIME NULL,
    [BaseCalculo]   MONEY         NULL,
    [Comissao]      REAL          NULL,
    [ValorComissao] MONEY         NULL,
    [Baixado]       VARCHAR (50)  NULL,
    [Tipo]          CHAR (1)      NOT NULL,
    CONSTRAINT [PK_TabVendedorAux] PRIMARY KEY NONCLUSTERED ([Pedido] ASC, [NotaFiscal] ASC, [Parcela] ASC, [Vencimento] ASC, [Tipo] ASC) WITH (FILLFACTOR = 90)
);

