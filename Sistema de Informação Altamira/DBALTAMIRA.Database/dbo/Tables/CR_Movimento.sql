CREATE TABLE [dbo].[CR_Movimento] (
    [crmo_Codigo]     CHAR (14)     NOT NULL,
    [crmo_NotaFiscal] INT           NOT NULL,
    [crmo_TipoNota]   CHAR (1)      NOT NULL,
    [crmo_Parcela]    SMALLINT      NOT NULL,
    [crmo_Emissao]    SMALLDATETIME NOT NULL,
    [crmo_Vencimento] SMALLDATETIME NOT NULL,
    [crmo_Pagamento]  SMALLDATETIME NULL,
    [crmo_Valor]      MONEY         NOT NULL,
    [crmo_Banco]      CHAR (3)      NULL,
    [crmo_Lock]       BINARY (8)    NULL
);

