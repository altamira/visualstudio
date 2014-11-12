CREATE TABLE [dbo].[SI_Auxiliar] (
    [si_Nome]      CHAR (30)  NOT NULL,
    [si_Sistema]   CHAR (2)   NOT NULL,
    [si_Descricao] CHAR (60)  NOT NULL,
    [si_Valor]     FLOAT (53) NOT NULL,
    [si_Lock]      BINARY (8) NULL
);

