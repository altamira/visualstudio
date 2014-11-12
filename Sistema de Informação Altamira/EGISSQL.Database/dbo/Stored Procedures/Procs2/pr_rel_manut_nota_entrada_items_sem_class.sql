
CREATE PROCEDURE pr_rel_manut_nota_entrada_items_sem_class
@ic_comercial char(1),
@dt_inicial datetime,
@dt_final   datetime

as

SELECT
  f.nm_fantasia_fornecedor,
  f.cd_fornecedor

  , ne.cd_nota_entrada

  , opf.cd_mascara_operacao
  , opf.cd_lancamento_padrao

  , nei.cd_item_nota_entrada
  , nei.nm_produto_nota_entrada  
  , nei.cd_tributacao

FROM
  Nota_Entrada ne

  LEFT OUTER JOIN
  Fornecedor f
  ON
  ne.cd_fornecedor = f.cd_fornecedor

  LEFT OUTER JOIN
  Operacao_Fiscal opf
  ON
  ne.cd_operacao_fiscal = opf.cd_operacao_fiscal

  LEFT OUTER JOIN
  Nota_Entrada_Item nei
  on ne.cd_nota_entrada      = nei.cd_nota_entrada and
     ne.cd_fornecedor        = nei.cd_fornecedor   and
     ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal and
     ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
  
WHERE
  ne.dt_receb_nota_entrada BETWEEN @dt_inicial AND @dt_final
  and
  ( isnull(nei.cd_classificacao_fiscal,0) = 0 )
  and
  ((@ic_comercial = 'A') or (opf.ic_comercial_operacao = @ic_comercial))

ORDER BY
  f.nm_fantasia_fornecedor,
  ne.cd_nota_entrada,
  nei.cd_item_nota_entrada

