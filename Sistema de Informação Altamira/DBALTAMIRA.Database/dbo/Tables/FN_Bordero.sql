CREATE TABLE [dbo].[FN_Bordero] (
    [fnbo_NotaFiscal]     INT           NOT NULL,
    [fnbo_TipoNota]       CHAR (1)      NOT NULL,
    [fnbo_Parcela]        TINYINT       NOT NULL,
    [fnbo_Banco]          CHAR (3)      NOT NULL,
    [fnbo_DataVencimento] SMALLDATETIME NOT NULL,
    [fnbo_ValorDuplicata] MONEY         NOT NULL,
    [fnbo_ValorIOF]       MONEY         NOT NULL,
    [fnbo_ValorJuros]     MONEY         NOT NULL,
    [fnbo_ValorCustos]    MONEY         NOT NULL,
    [fnbo_Dias]           TINYINT       NOT NULL,
    [fnbo_Cliente]        CHAR (14)     NOT NULL,
    [fnbo_Lock]           BINARY (8)    NULL
);

