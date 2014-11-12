CREATE TABLE [dbo].[SI_REGISTRO54] (
    [Tipo]          CHAR (2)  NULL,
    [CNPJ]          CHAR (14) NOT NULL,
    [ModeloNF]      CHAR (2)  NULL,
    [SerieNF]       CHAR (3)  NULL,
    [NumeroNF]      CHAR (6)  NOT NULL,
    [CFOP]          CHAR (4)  NOT NULL,
    [CST]           CHAR (3)  NULL,
    [NumItem]       CHAR (3)  NOT NULL,
    [CodProduto]    CHAR (14) NULL,
    [Quantidade]    CHAR (11) NULL,
    [ValorProduto]  CHAR (12) NULL,
    [ValorDesconto] CHAR (12) NULL,
    [BaseICMS]      CHAR (12) NULL,
    [BaseICMSST]    CHAR (12) NULL,
    [ValorIPI]      CHAR (12) NULL,
    [AliqICMS]      CHAR (4)  NULL,
    CONSTRAINT [PK_SI_REGISTRO54] PRIMARY KEY NONCLUSTERED ([CNPJ] ASC, [NumeroNF] ASC, [CFOP] ASC, [NumItem] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_SI_REGISTRO54]
    ON [dbo].[SI_REGISTRO54]([CNPJ] ASC, [NumeroNF] ASC, [CFOP] ASC, [NumItem] ASC) WITH (FILLFACTOR = 90);

