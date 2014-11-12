CREATE TABLE [dbo].[VE_Montagem] (
    [vemo_Codigo]      INT         NOT NULL,
    [vemo_Descricao]   CHAR (40)   NULL,
    [vemo_porcentagem] DECIMAL (2) NULL,
    [vemo_lock]        BINARY (8)  NULL,
    CONSTRAINT [PK_VE_Montagem] PRIMARY KEY NONCLUSTERED ([vemo_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Montagem] TO [interclick]
    AS [dbo];

