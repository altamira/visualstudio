CREATE TABLE [dbo].[CP_NotaFiscal] (
    [cpnf_Fornecedor]  CHAR (14)     NOT NULL,
    [cpnf_Notafiscal]  CHAR (6)      NOT NULL,
    [cpnf_TipoNota]    CHAR (1)      NOT NULL,
    [cpnf_Pedido]      INT           NOT NULL,
    [cpnf_DataEmissao] SMALLDATETIME CONSTRAINT [DF_CP_NotaFiscal_cpnf_DataEmissao] DEFAULT (NULL) NULL,
    [cpnf_DataEntrada] SMALLDATETIME CONSTRAINT [DF_CP_NotaFiscal_cpnf_DataEntrada] DEFAULT (NULL) NULL,
    [cpnf_ValorTotal]  MONEY         NOT NULL,
    [cpnf_Parcelas]    SMALLINT      NOT NULL,
    [cpnf_JaIncluso]   CHAR (1)      NULL,
    [cpnf_Lock]        ROWVERSION    NOT NULL,
    CONSTRAINT [PK_CP_NotaFiscal] PRIMARY KEY NONCLUSTERED ([cpnf_Fornecedor] ASC, [cpnf_Notafiscal] ASC, [cpnf_TipoNota] ASC, [cpnf_Pedido] ASC) WITH (FILLFACTOR = 90)
);

