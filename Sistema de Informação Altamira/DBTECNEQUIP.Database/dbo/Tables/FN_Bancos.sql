CREATE TABLE [dbo].[FN_Bancos] (
    [fnba_Codigo]       CHAR (3)   NOT NULL,
    [fnba_NomeBanco]    CHAR (15)  NOT NULL,
    [fnba_ValorTaxa]    MONEY      NOT NULL,
    [fnba_ValorBordero] MONEY      NOT NULL,
    [fnba_Lock]         ROWVERSION NOT NULL,
    CONSTRAINT [PK_FN_Bancos] PRIMARY KEY NONCLUSTERED ([fnba_Codigo] ASC) WITH (FILLFACTOR = 90)
);

