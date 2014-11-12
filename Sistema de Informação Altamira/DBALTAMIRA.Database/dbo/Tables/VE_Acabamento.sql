CREATE TABLE [dbo].[VE_Acabamento] (
    [veac_Codigo]    TINYINT      NOT NULL,
    [veac_Descricao] VARCHAR (46) NOT NULL,
    [veac_Custo]     FLOAT (53)   NOT NULL,
    [veac_Lock]      BINARY (8)   NULL,
    CONSTRAINT [PK_VE_Acabamento] PRIMARY KEY NONCLUSTERED ([veac_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Acabamento]
    ON [dbo].[VE_Acabamento]([veac_Descricao] ASC) WITH (FILLFACTOR = 90);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Acabamento] TO [interclick]
    AS [dbo];

