
CREATE PROCEDURE pr_entrada_produto_inspecao


@cd_produto int


AS

SELECT
  dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as cd_mascara_produto,
  p.nm_fantasia_produto,
  f.nm_fantasia_fornecedor,
  ne.cd_nota_entrada,
  ne.dt_nota_entrada,
  nei.cd_item_nota_entrada,
  nei.qt_item_nota_entrada,
  nei.vl_item_nota_entrada,
  nei.vl_total_nota_entr_item  

FROM
  Produto p
  LEFT OUTER JOIN
  Nota_Entrada_Item nei
  ON   
  p.cd_produto = nei.cd_produto
  LEFT OUTER JOIN
  Nota_Entrada ne
  ON
  nei.cd_nota_entrada = ne.cd_nota_entrada
  LEFT OUTER JOIN
  Fornecedor f
  ON
  ne.cd_fornecedor = f.cd_fornecedor
  LEFT OUTER JOIN
  Grupo_Produto gp
  ON
  p.cd_grupo_produto = gp.cd_grupo_produto

WHERE
  ((nei.cd_produto = @cd_produto) or (@cd_produto = 0))

