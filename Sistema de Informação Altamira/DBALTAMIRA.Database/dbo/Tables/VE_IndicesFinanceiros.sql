CREATE TABLE [dbo].[VE_IndicesFinanceiros] (
    [vein_Codigo]         TINYINT    NOT NULL,
    [vein_Inflacao]       FLOAT (53) NOT NULL,
    [vein_Juros]          FLOAT (53) NOT NULL,
    [vein_Icms]           FLOAT (53) NOT NULL,
    [vein_Cofins]         FLOAT (53) NOT NULL,
    [vein_Pis]            FLOAT (53) NOT NULL,
    [vein_Montagem]       FLOAT (53) NOT NULL,
    [vein_Comissao]       FLOAT (53) NOT NULL,
    [vein_Iss]            FLOAT (53) NOT NULL,
    [vein_Transporte]     FLOAT (53) NULL,
    [vein_Outros]         FLOAT (53) NULL,
    [vein_Embalagem]      FLOAT (53) NULL,
    [vein_Terceirizacao]  FLOAT (53) NULL,
    [vein_Lucro]          FLOAT (53) NULL,
    [vein_Investimentos]  FLOAT (53) NULL,
    [vein_Negociacao]     FLOAT (53) NULL,
    [vein_TaxaFinanceira] FLOAT (53) NULL,
    [vein_Lock]           BINARY (8) NULL,
    CONSTRAINT [PK_VE_IndicesFinanceiros] PRIMARY KEY NONCLUSTERED ([vein_Codigo] ASC) WITH (FILLFACTOR = 90)
);

