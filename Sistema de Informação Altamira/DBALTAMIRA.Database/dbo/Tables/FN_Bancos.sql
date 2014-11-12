CREATE TABLE [dbo].[FN_Bancos] (
    [fnba_Codigo]         CHAR (3)   NOT NULL,
    [fnba_NomeBanco]      CHAR (25)  NOT NULL,
    [fnba_ValorTaxa]      MONEY      NOT NULL,
    [fnba_ValorBordero]   MONEY      NOT NULL,
    [fnba_ValorLimite]    MONEY      NOT NULL,
    [fnba_financeiro]     CHAR (1)   NULL,
    [fnba_ChequeEspecial] MONEY      NULL,
    [fnba_Agencia]        CHAR (10)  NULL,
    [fnba_Contrato]       CHAR (15)  NULL,
    [fnba_Lock]           BINARY (8) NULL
);

