CREATE TABLE [dbo].[FA_NFEntradaFiscal] (
    [finf_NotaFiscal]     INT           NOT NULL,
    [finf_TipoNota]       CHAR (1)      NULL,
    [finf_DataNota]       SMALLDATETIME NULL,
    [finf_CNPJ]           CHAR (14)     NOT NULL,
    [finf_CFOP]           CHAR (6)      NOT NULL,
    [finf_ValorNF]        MONEY         NULL,
    [finf_ValorICMS]      MONEY         NULL,
    [finf_ValorIPI]       MONEY         NULL,
    [finf_TipoMaterial]   CHAR (30)     NULL,
    [finf_DataReferencia] SMALLDATETIME NULL,
    CONSTRAINT [PK_FA_NFEntradaFiscal] PRIMARY KEY NONCLUSTERED ([finf_NotaFiscal] ASC, [finf_CNPJ] ASC, [finf_CFOP] ASC) WITH (FILLFACTOR = 90)
);

