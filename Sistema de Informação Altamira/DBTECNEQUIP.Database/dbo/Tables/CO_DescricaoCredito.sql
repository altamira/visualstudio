CREATE TABLE [dbo].[CO_DescricaoCredito] (
    [codc_Codigo]    CHAR (1)   NOT NULL,
    [codc_Descricao] CHAR (30)  NOT NULL,
    [codc_Lock]      ROWVERSION NOT NULL,
    CONSTRAINT [PK_CO_DescricaoCredito] PRIMARY KEY NONCLUSTERED ([codc_Codigo] ASC) WITH (FILLFACTOR = 90)
);

