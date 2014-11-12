CREATE TABLE [dbo].[CR_Bordero] (
    [crbo_NotaFiscal]     INT           NOT NULL,
    [crbo_TipoNota]       CHAR (1)      NOT NULL,
    [crbo_Parcela]        TINYINT       NOT NULL,
    [crbo_Banco]          CHAR (3)      NOT NULL,
    [crbo_Agencia]        CHAR (10)     NULL,
    [crbo_Contrato]       CHAR (20)     NULL,
    [crbo_Cliente]        CHAR (14)     NULL,
    [crbo_DataVencimento] SMALLDATETIME NOT NULL,
    [crbo_ValorDuplicata] MONEY         NOT NULL,
    [crbo_ValorIOF]       MONEY         NOT NULL,
    [crbo_ValorJuros]     MONEY         NOT NULL,
    [crbo_ValorCustos]    MONEY         NOT NULL,
    [crbo_Dias]           TINYINT       NOT NULL,
    [crbo_Lock]           BINARY (8)    NULL
);

