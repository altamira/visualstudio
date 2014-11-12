
create procedure pr_consulta_liberacao_produto_estoque

 @dt_inicial as datetime, 
 @dt_final   as datetime
   as
    
 
declare @qt_item_nota_entrada float
declare @qtd_registro int

select
  @qt_item_nota_entrada = sum(nei.qt_item_nota_entrada),
  @qtd_registro = count('x')
FROM  
  Nota_Entrada_Item nei left outer join
  Nota_Entrada ne ON nei.cd_fornecedor = ne.cd_fornecedor and
                     nei.cd_nota_entrada = ne.cd_nota_entrada and
                     nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal left outer join
 Produto p ON nei.cd_produto = p.cd_produto left outer join
 Serie_Nota_Fiscal snf ON nei.cd_serie_nota_fiscal = snf.cd_serie_nota_fiscal left outer join
 Unidade_Medida um ON nei.cd_unidade_medida = um.cd_unidade_medida left outer join
 Fornecedor f ON nei.cd_fornecedor = f.cd_fornecedor
where
  IsNull(nei.ic_estocado_nota_entrada,'N') = 'N' and
  IsNull(nei.ic_item_inspecao_nota,'N') = 'S' and
  ne.dt_nota_entrada between @dt_inicial and @dt_final and
  nei.cd_produto is not null


SELECT   
  0 as Sel,
  isnull(cast(0 as integer),0) as 'qtsaldoatual',
  isnull(cast(0 as integer),0) as 'qtdispo',
  dbo.fn_mascara_produto(nei.cd_produto) as cd_mascara_produto,
  p.nm_fantasia_produto,
  nei.nm_produto_nota_entrada, 
  um.sg_unidade_medida,
  nei.qt_item_nota_entrada, 
  f.nm_fantasia_fornecedor, 
  ne.dt_nota_entrada, 
  ne.dt_receb_nota_entrada, 
  nei.cd_nota_entrada, 
  snf.sg_serie_nota_fiscal, 
  ne.cd_operacao_fiscal,
  ne.cd_serie_nota_fiscal,
  nei.cd_item_nota_entrada,
  nei.vl_item_nota_entrada,
  nei.ic_consig_nota_entrada,
  IsNull(p.cd_produto_baixa_estoque, p.cd_produto) as cd_produto_baixa,
  ne.cd_tipo_destinatario,
  ne.cd_fornecedor,
  nei.cd_lote_item_nota_entrada as 'cd_lote_produto',
  nei.cd_pedido_compra,
  nei.cd_item_pedido_compra,
  isnull(@qt_item_nota_entrada,0) as 'qtd_item_total',
  isnull(@qtd_registro,0) as 'qtd_registro',
  dt_validade = ( select max(dt_final_lote_produto) from Lote_Produto where nm_ref_lote_produto = nei.cd_lote_item_nota_entrada )
FROM  
  Nota_Entrada_Item nei left outer join
  Nota_Entrada ne ON nei.cd_fornecedor = ne.cd_fornecedor and
                     nei.cd_nota_entrada = ne.cd_nota_entrada and
                     nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal left outer join
 Produto p ON nei.cd_produto = p.cd_produto left outer join
 Serie_Nota_Fiscal snf ON nei.cd_serie_nota_fiscal = snf.cd_serie_nota_fiscal left outer join
 Unidade_Medida um ON nei.cd_unidade_medida = um.cd_unidade_medida left outer join
 Fornecedor f ON nei.cd_fornecedor = f.cd_fornecedor 

where
  IsNull(nei.ic_estocado_nota_entrada,'N') = 'N' and
  IsNull(nei.ic_item_inspecao_nota,'N') = 'N' and
  ne.dt_nota_entrada between @dt_inicial and @dt_final and
  nei.cd_produto is not null and
  p.ic_inspecao_produto = 'S'

