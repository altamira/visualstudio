CREATE TABLE [dbo].[FF_Bancos] (
    [ffba_Codigo]       CHAR (3)   NOT NULL,
    [ffba_NomeBanco]    CHAR (15)  NOT NULL,
    [ffba_ValorTaxa]    MONEY      NOT NULL,
    [ffba_ValorBordero] MONEY      NOT NULL,
    [ffba_Lock]         BINARY (8) NULL
);

