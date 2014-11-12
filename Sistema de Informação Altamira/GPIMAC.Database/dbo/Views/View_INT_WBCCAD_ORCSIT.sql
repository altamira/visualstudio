CREATE VIEW [View_INT_WBCCAD_ORCSIT] AS SELECT     idIntegracao_OrcSit AS INT_ORCSIT_ID,            ORCNUM              AS INT_ORCSIT_OrcNum,            SITCOD              AS INT_ORCSIT_SitCod,            ORCALTDTH           AS INT_ORCSIT_DtHAlt FROM       WBCCAD..INTEGRACAO_ORCSIT 
GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_ORCSIT] TO [interclick]
    AS [dbo];

