
--------------------------------------------------------------------------------
CREATE PROCEDURE pr_consulta_produto_sem_classificacao_fiscal
@cd_status_produto as int
AS 

SELECT
  p.cd_produto,
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
  p.nm_produto,
  p.nm_fantasia_produto,
  gp.nm_fantasia_grupo_produto,
  sp.nm_serie_produto,
  (select top 1 cd_nota_entrada from Nota_Entrada_Item where cd_produto = p.cd_produto order by dt_item_receb_nota_entrad desc) as cd_nota_entrada,
  (select top 1 cd_classificacao_fiscal from Nota_Entrada_Item where cd_produto = p.cd_produto order by dt_item_receb_nota_entrad desc) as cd_classificacao,
  (select top 1 cd_mascara_classificacao from Nota_Entrada_Item where cd_produto = p.cd_produto order by dt_item_receb_nota_entrad desc) as cd_mascara_classificacao
FROM 
  Produto p
  LEFT OUTER JOIN 
  Produto_Fiscal pf
  ON
  p.cd_produto = pf.cd_produto
  LEFT OUTER JOIN
  Grupo_Produto gp
  ON
  p.cd_grupo_produto = gp.cd_grupo_produto
  LEFT OUTER JOIN
  Serie_Produto sp
  ON
  p.cd_serie_produto = sp.cd_serie_produto 
WHERE
  isnull(pf.cd_classificacao_fiscal, '') = '' and 
  ((@cd_status_produto = 0) or (p.cd_status_produto = @cd_status_produto))



