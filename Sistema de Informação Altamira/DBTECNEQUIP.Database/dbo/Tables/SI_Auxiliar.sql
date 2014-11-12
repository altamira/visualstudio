CREATE TABLE [dbo].[SI_Auxiliar] (
    [si_Nome]      CHAR (30)  NOT NULL,
    [si_Sistema]   CHAR (2)   NOT NULL,
    [si_Descricao] CHAR (30)  NOT NULL,
    [si_Valor]     FLOAT (53) NOT NULL,
    [si_Lock]      ROWVERSION NOT NULL,
    CONSTRAINT [PK_SI_Auxiliar] PRIMARY KEY NONCLUSTERED ([si_Nome] ASC) WITH (FILLFACTOR = 90)
);

