CREATE TABLE [dbo].[VE_Transporte] (
    [vett_Codigo]      INT        NOT NULL,
    [vett_Descricao]   CHAR (40)  NULL,
    [vett_Porcentagem] REAL       NULL,
    [vett_Aditivo]     REAL       NULL,
    [vett_Final]       REAL       NULL,
    [vett_Lock]        BINARY (8) NULL,
    CONSTRAINT [PK_VE_Transporte] PRIMARY KEY NONCLUSTERED ([vett_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Transporte] TO [interclick]
    AS [dbo];

