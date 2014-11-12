CREATE TABLE [dbo].[VE_Cidades] (
    [vees_Nome]  CHAR (30) NOT NULL,
    [vees_Sigla] CHAR (2)  NOT NULL,
    [vees_ICMS]  INT       NULL,
    CONSTRAINT [PK_VE_Cidades] PRIMARY KEY NONCLUSTERED ([vees_Nome] ASC) WITH (FILLFACTOR = 90)
);

