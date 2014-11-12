

/****** Object:  Stored Procedure dbo.pr_resumo_consulta_perda    Script Date: 13/12/2002 15:08:41 ******/
CREATE PROCEDURE pr_resumo_consulta_perda

@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime,
@cd_concorrente int,
@cd_grupo_produto int

AS

--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 -- Consulta por Concorrente
--------------------------------------------------------------------------------------------  

begin
  
  --------------------------------------------------------------------------------------------
  If @cd_concorrente = 0 -- Todos os Concorrentes
  --------------------------------------------------------------------------------------------  
  begin
 
    SELECT
      gru.cd_grupo_produto,
      gru.nm_grupo_produto,
      CON.NM_CONCORRENTE,  
      SUM(CI.QT_ITEM_CONSULTA * CI.VL_UNITARIO_ITEM_CONSULTA) AS 'VL_NOSSO',
      SUM(CI.QT_ITEM_CONSULTA * CONSULTA_ITEM_PERDA.VL_PERDA_CONSULTA) AS 'VL_PERDA'
    FROM         CONSULTA_ITEM_PERDA
      INNER JOIN 
        CONSULTA_ITENS CI
      ON
        CONSULTA_ITEM_PERDA.CD_CONSULTA = CI.CD_CONSULTA AND
        CONSULTA_ITEM_PERDA.CD_ITEM_CONSULTA = CI.CD_ITEM_CONSULTA
      INNER JOIN
        CONCORRENTE CON
      ON 
        CONSULTA_ITEM_PERDA.CD_CONCORRENTE = CON.CD_CONCORRENTE
      INNER JOIN
        Grupo_Produto gru ON ci.cd_grupo_produto = gru.cd_grupo_produto

      GROUP BY CON.NM_CONCORRENTE, gru.cd_grupo_produto, gru.nm_grupo_produto

  end
  else
  begin
    SELECT
      gru.cd_grupo_produto,
      gru.nm_grupo_produto,
      CON.NM_CONCORRENTE,  
      SUM(CI.QT_ITEM_CONSULTA * CI.VL_UNITARIO_ITEM_CONSULTA) AS 'VL_NOSSO',
      SUM(CI.QT_ITEM_CONSULTA * CONSULTA_ITEM_PERDA.VL_PERDA_CONSULTA) AS 'VL_PERDA'
    FROM         CONSULTA_ITEM_PERDA
      INNER JOIN
        CONSULTA_ITENS CI
      ON
        CONSULTA_ITEM_PERDA.CD_CONSULTA = CI.CD_CONSULTA AND
        CONSULTA_ITEM_PERDA.CD_ITEM_CONSULTA = CI.CD_ITEM_CONSULTA
      INNER JOIN
        CONCORRENTE CON ON CONSULTA_ITEM_PERDA.CD_CONCORRENTE = CON.CD_CONCORRENTE
      INNER JOIN
        Grupo_Produto gru ON ci.cd_grupo_produto = gru.cd_grupo_produto

      where
        con.cd_concorrente = @cd_concorrente
      GROUP BY CON.NM_CONCORRENTE, gru.cd_grupo_produto, gru.nm_grupo_produto
  end
end

--------------------------------------------------------------------------------------------
  If @ic_parametro = 2 -- Consulta por Grupo de Produto
--------------------------------------------------------------------------------------------  

begin

Select
      gru.nm_grupo_produto,
      sum(ci.qt_item_consulta * ci.vl_unitario_item_consulta) as 'vl_nosso',
      sum(ci.qt_item_consulta * Consulta_Item_Perda.vl_perda_consulta) as 'vl_perda'
FROM         Consulta_Item_Perda
      INNER JOIN
        Consulta_Itens ci
      ON
        consulta_item_perda.cd_consulta = ci.cd_consulta and
        consulta_item_perda.cd_item_consulta = ci.cd_item_consulta
      INNER JOIN
        Grupo_Produto gru ON ci.cd_grupo_produto = gru.cd_grupo_produto
      where 
        ci.cd_grupo_produto = @cd_grupo_produto
      group by gru.nm_grupo_produto

end

--------------------------------------------------------------------------------------------
  If @ic_parametro = 3 -- Consulta por Serie
--------------------------------------------------------------------------------------------  

BEGIN
SELECT
CI.CD_SERIE_PRODUTO,
SP.NM_SERIE_PRODUTO,
SUM(CI.QT_ITEM_CONSULTA * CI.VL_UNITARIO_ITEM_CONSULTA) AS 'VL_NOSSO',
SUM(CI.QT_ITEM_CONSULTA * CONSULTA_ITEM_PERDA.VL_PERDA_CONSULTA) AS 'VL_PERDA'
FROM         CONSULTA_ITEM_PERDA
    INNER JOIN
    CONSULTA_ITENS CI
     ON
         CONSULTA_ITEM_PERDA.CD_CONSULTA = CI.CD_CONSULTA AND
         CONSULTA_ITEM_PERDA.CD_ITEM_CONSULTA = CI.CD_ITEM_CONSULTA
     INNER JOIN
      GRUPO_PRODUTO GRU ON CI.CD_GRUPO_PRODUTO = GRU.CD_GRUPO_PRODUTO
     INNER JOIN
	      SERIE_PRODUTO SP
     ON
      SP.CD_SERIE_PRODUTO = CI.CD_SERIE_PRODUTO
WHERE
CONSULTA_ITEM_PERDA.CD_CONCORRENTE = @CD_CONCORRENTE   

GROUP BY CI.CD_SERIE_PRODUTO, SP.NM_SERIE_PRODUTO

END




