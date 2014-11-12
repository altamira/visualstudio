CREATE TABLE [dbo].[FA_Empresas] (
    [faem_Codigo]     CHAR (14)    NOT NULL,
    [faem_Nome]       VARCHAR (35) NOT NULL,
    [faem_Endereco]   VARCHAR (35) NOT NULL,
    [faem_Inscricao]  CHAR (14)    NOT NULL,
    [faem_NotaFiscal] INT          NOT NULL,
    [faem_PIS]        FLOAT (53)   NULL,
    [faem_COFINS]     FLOAT (53)   NULL,
    [faem_Lock]       BINARY (8)   NULL,
    CONSTRAINT [PK_FA_Empresas] PRIMARY KEY NONCLUSTERED ([faem_Codigo] ASC) WITH (FILLFACTOR = 90)
);

