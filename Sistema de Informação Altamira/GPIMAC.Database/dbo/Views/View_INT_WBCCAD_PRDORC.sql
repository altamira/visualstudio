CREATE VIEW [View_INT_WBCCAD_PRDORC] AS SELECT     Produto        AS INT_PRDORC_Produto,            Descricao      AS INT_PRDORC_Descricao,            UPPER(Unidade) AS INT_PRDORC_Unidade,            Peso           AS INT_PRDORC_Peso,            Familia        AS INT_PRDORC_Familia,            Situacao       AS INT_PRDORC_Situacao FROM       WBCCAD..prdorc 
GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_PRDORC] TO [interclick]
    AS [dbo];

