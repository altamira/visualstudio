CREATE TABLE [dbo].[CP_NotaFiscal] (
    [cpnf_Fornecedor]  CHAR (14)     NOT NULL,
    [cpnf_Notafiscal]  CHAR (6)      NOT NULL,
    [cpnf_TipoNota]    CHAR (1)      NOT NULL,
    [cpnf_Pedido]      INT           NOT NULL,
    [cpnf_DataEmissao] SMALLDATETIME NOT NULL,
    [cpnf_DataEntrada] SMALLDATETIME NOT NULL,
    [cpnf_ValorTotal]  MONEY         NOT NULL,
    [cpnf_Parcelas]    SMALLINT      NOT NULL,
    [cpnf_JaIncluso]   CHAR (1)      NOT NULL,
    [cpnf_Lock]        BINARY (8)    NULL,
    CONSTRAINT [PK_CP_NotaFiscal] PRIMARY KEY NONCLUSTERED ([cpnf_Fornecedor] ASC, [cpnf_Notafiscal] ASC, [cpnf_TipoNota] ASC, [cpnf_Pedido] ASC) WITH (FILLFACTOR = 90)
);

