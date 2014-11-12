CREATE VIEW [View_INT_WBCCAD_ORCIND] AS SELECT     idIntegracao_OrcInd AS INT_ORCIND_ID,            ORCNUM              AS INT_ORCIND_OrcNum,            TIPINDCOD           AS INT_ORCIND_TipIndCod,            ORCVAL AS INT_ORCIND_OrcVal FROM         WBCCAD..INTEGRACAO_ORCIND
GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_ORCIND] TO [interclick]
    AS [dbo];

