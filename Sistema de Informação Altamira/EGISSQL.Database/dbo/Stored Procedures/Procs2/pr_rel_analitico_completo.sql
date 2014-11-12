
---------------------------------------------------------
--pr_rel_analitico_completo
---------------------------------------------------------
--gbs - global business solution	             2001
---------------------------------------------------------
--stored procedure	: microsoft sql server       2000
--autor(es)		: rafael m. santiago
--banco de dados	: egissql
--objetivo		: relatório analítico de notas fiscais de entrada
--data			: 12/09/03
--alteração		: 17.09.2004 - Nome Fantasia do Produto - Carlos Fernandes
--
--------------------------------------------------------------------------------------------------------------------



create procedure pr_rel_analitico_completo

@dt_inicial datetime,
@dt_final   datetime,
@cd_fornecedor int = 0

as


select
	f.nm_fantasia as nm_fantasia_fornecedor, 
        ne.cd_nota_entrada,
	ne.dt_nota_entrada,
	ne.dt_receb_nota_entrada,
	opf.cd_mascara_operacao,
	opf.cd_tributacao,
	isnull(ner.cd_rem,0)                   as cd_rem,
	isnull(ne.vl_bicms_nota_entrada,0)     as vl_bicms_nota_entrada, -- baseicms
	isnull(ne.vl_icms_nota_entrada,0)      as vl_icms_nota_entrada, -- valoricms
	isnull(ne.vl_bsticm_nota_entrada,0)    as vl_bsticm_nota_entrada, -- base subst
	isnull(ne.vl_sticm_nota_entrada,0)     as vl_sticm_nota_entrada, -- valor subst
	isnull(ne.vl_prod_nota_entrada,0)      as vl_prod_nota_entrada, -- total prod
	isnull(ne.vl_frete_nota_entrada,0)     as vl_frete_nota_entrada, -- valor frete
	isnull(ne.vl_seguro_nota_entrada,0)    as vl_seguro_nota_entrada, -- valor seguro
	isnull(ne.vl_despac_nota_entrada,0)    as vl_despac_nota_entrada, -- outras desp
	isnull(ne.vl_ipi_nota_entrada,0)       as vl_ipi_nota_entrada, -- valor ipi
	isnull(ne.vl_total_nota_entrada,0)     as vl_total_nota_entrada, -- total nota
-- itens
	dbo.fn_mascara_produto(nei.cd_produto) as cd_mascara_produto,
        p.nm_fantasia_produto,                 
	nei.nm_produto_nota_entrada,
	nei.qt_item_nota_entrada, 
  un.sg_unidade_medida,
	isnull(nei.qt_pesliq_nota_entrada,0)   as qt_pesliq_nota_entrada, -- peso liquido
 	isnull(nei.vl_item_nota_entrada,0)     as vl_item_nota_entrada, -- unitário
	isnull(nei.vl_total_nota_entr_item,0)  as vl_total_nota_entr_item, -- total
	isnull(nei.pc_icms_nota_entrada,0)     as pc_icms_nota_entrada, -- %icm
	isnull(nei.pc_ipi_nota_entrada,0)      as pc_ipi_nota_entrada, -- %ipi
	isnull(pci.cd_pedido_venda,0)          as cd_pedido_venda, -- pedido venda
  td.nm_tipo_destinatario,
  me.cd_movimento_estoque,
  (isnull(me.vl_custo_contabil_produto,0) * nei.qt_item_nota_entrada) as 'vl_custo_total_produto'
from 
	nota_entrada ne
left outer join
	vw_destinatario f
on
	ne.cd_fornecedor = f.cd_destinatario and 
  ne.cd_tipo_destinatario = f.cd_tipo_destinatario
left outer join
  tipo_destinatario td 
on
  f.cd_tipo_destinatario = td.cd_tipo_destinatario
left outer join
	nota_entrada_item nei
on
	ne.cd_nota_entrada = nei.cd_nota_entrada and
  ne.cd_fornecedor = nei.cd_fornecedor and
  ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
left outer join
  movimento_estoque me 
on 
  me.cd_fornecedor = nei.cd_fornecedor and
  me.cd_documento_movimento = cast(nei.cd_nota_entrada as varchar) and
  me.cd_operacao_fiscal = nei.cd_operacao_fiscal and
  me.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
  me.cd_item_documento = nei.cd_item_nota_entrada and                                       
  me.cd_tipo_documento_estoque = 3
left outer join
  unidade_Medida un
on
  un.cd_unidade_medida = nei.cd_unidade_medida
left outer join
	operacao_fiscal opf
on
	ne.cd_operacao_fiscal = opf.cd_operacao_fiscal
left outer join
	pedido_compra_item pci
on
	nei.cd_pedido_compra = pci.cd_pedido_compra and
	nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
left outer join
  nota_entrada_registro ner
on
  ner.cd_nota_entrada    = ne.cd_nota_entrada and
  ner.cd_fornecedor      = ne.cd_fornecedor and
  ner.cd_operacao_fiscal = ne.cd_operacao_fiscal
left outer join Produto p on p.cd_produto = nei.cd_produto
where 
	ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
  ne.cd_fornecedor = (case isnull(@cd_fornecedor,0)
                      when 0 then ne.cd_fornecedor
                      else @cd_fornecedor  
                      end)
order by
  f.nm_fantasia,
  ne.cd_nota_entrada,
  nei.cd_item_nota_entrada

