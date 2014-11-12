CREATE TABLE [dbo].[INTEGRACAO_ORCIND] (
    [ORCNUM]              NVARCHAR (8)  NULL,
    [TIPINDCOD]           NVARCHAR (20) NULL,
    [ORCVAL]              MONEY         NULL,
    [idIntegracao_OrcInd] INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_INTEGRACAO_ORCIND] PRIMARY KEY CLUSTERED ([idIntegracao_OrcInd] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[INTEGRACAO_ORCIND] TO [interclick]
    AS [dbo];

