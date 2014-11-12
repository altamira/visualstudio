
CREATE PROCEDURE pr_manutencao_nota_entrada
@dt_inicial datetime,
@dt_final   datetime

as

SELECT
  ne.cd_nota_entrada,
  ne.dt_receb_nota_entrada,
  f.nm_fantasia_fornecedor,
  ne.cd_rem,
  dp.nm_destinacao_produto,
  opf.cd_mascara_operacao,
  ner.cd_tributacao,
  opf.cd_lancamento_padrao,
  ne.vl_total_nota_entrada,
  ne.vl_icms_nota_entrada,
  ne.vl_ipi_nota_entrada,
  nei.cd_item_nota_entrada,
  nei.cd_classificacao_fiscal,
  nei.nm_produto_nota_entrada,
  (SELECT TOP 1 pc.cd_mascara_plano_compra 
   FROM
     Plano_Compra pc
   WHERE
     nei.cd_plano_compra = pc.cd_plano_compra) as cd_mascara_plano_compra,
  isnull((select sum(x.vl_bicms_reg_nota_entrada)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'BaseCalculoICM',
  isnull((select sum(x.vl_bipi_reg_nota_entrada)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'BaseCalculoIPI',
  isnull((select sum(x.pc_icms_reg_nota_entrada)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'AliquotaICM',  
  isnull((select sum(x.pc_ipi_reg_nota_entrada)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'AliquotaIPI',
  isnull((select sum(x.vl_icms_reg_nota_entrada)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'ImpostoDevidoICM',
  isnull((select sum(x.vl_ipi_reg_nota_entrada)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'ImpostoDevidoIPI',
  isnull((select sum(x.vl_icmsisen_reg_nota_entr)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'IsentasICM',
  isnull((select sum(x.vl_ipiisen_reg_nota_entr)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'IsentasIPI',
  isnull((select sum(x.vl_icmsoutr_reg_nota_entr)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'OutrasICM',
  isnull((select sum(x.vl_ipioutr_reg_nota_entr)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'OutrasIPI',
  isnull((select sum(x.vl_icmsobs_reg_nota_entr)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'ObservacaoICM',
  isnull((select sum(x.vl_ipiobs_reg_nota_entr)
     from Nota_Entrada_Item_Registro x 
     where x.cd_nota_entrada = ne.cd_nota_entrada), 0) as 'ObservacaoIPI'

FROM
  Nota_Entrada ne 
  LEFT OUTER JOIN
  Fornecedor f
  ON
  ne.cd_fornecedor = f.cd_fornecedor
  LEFT OUTER JOIN
  Destinacao_Produto dp
  ON
  ne.cd_destinacao_produto = dp.cd_destinacao_produto
  LEFT OUTER JOIN
  Nota_Entrada_Item nei
  ON
  ne.cd_nota_entrada = nei.cd_nota_entrada
  LEFT OUTER JOIN
  Operacao_Fiscal opf
  ON
  ne.cd_operacao_fiscal = opf.cd_operacao_fiscal
  LEFT OUTER JOIN
  Nota_Entrada_Registro ner
  ON
  ne.cd_nota_entrada = ner.cd_nota_entrada
  
WHERE
  nei.cd_classificacao_fiscal IS NULL AND
  ne.dt_receb_nota_entrada BETWEEN @dt_inicial AND @dt_final
GROUP BY
  ne.cd_nota_entrada,
  ne.dt_receb_nota_entrada,
  f.nm_fantasia_fornecedor,
  ne.cd_rem,
  dp.nm_destinacao_produto,
  opf.cd_mascara_operacao,
  ner.cd_tributacao,
  opf.cd_lancamento_padrao,
  ne.vl_total_nota_entrada,
  ne.vl_icms_nota_entrada,
  ne.vl_ipi_nota_entrada,
  nei.cd_item_nota_entrada,
  nei.cd_classificacao_fiscal,
  nei.nm_produto_nota_entrada,
  nei.cd_plano_compra
ORDER BY
  ne.cd_nota_entrada,
  nei.cd_item_nota_entrada

