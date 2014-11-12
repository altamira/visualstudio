
--pr_rel_nota_entrada_matprima
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Rafael M. Santiago
--Banco de Dados	: EGISSQL
--Objetivo		: Relatóriode Notas Fiscais de Entrada - Matéria-Prima
--Data			: 18/09/03
--Alteração		: 15/12/2005 - Ajuste para Listar Produtos Padrão que também 
--                                     são Matéria-Prima - ELIAS
---------------------------------------------------
CREATE PROCEDURE pr_rel_nota_entrada_matprima

@dt_inicial datetime,
@dt_final   datetime

AS

  select distinct
    f.nm_fantasia_fornecedor,
    ne.cd_nota_entrada,
    ne.dt_nota_entrada,
    ne.dt_receb_nota_entrada,
    opf.cd_mascara_operacao,
    opf.cd_tributacao,
    isnull(ne.cd_rem,0)                    as cd_rem,
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
    isnull(pci.cd_pedido_compra,0)         AS cd_pedido_compra, -- Pedido Compra
    pci.cd_item_pedido_compra,
    mp.sg_mat_prima as Aco,
    nm_fantasia_produto =
    case when isnull(nm_fantasia_produto,'') <> '' then nm_fantasia_produto
    else pci.nm_placa end,
    pci.nm_fantasia_produto, -- Placa
    nm_fantasia_mat_prima =
    case when isnull(pci.cd_materia_prima, isnull(pc.cd_mat_prima,0)) > 0 and pci.nm_placa <> '' then
    pci.nm_medbruta_mat_prima else nei.nm_produto_nota_entrada end,
    nei.qt_item_nota_entrada,
    isnull(nei.qt_pesbru_nota_entrada,0)   as qt_pesliq_nota_entrada, -- peso liquido
    isnull(nei.vl_item_nota_entrada,0)     as vl_item_nota_entrada, -- unitário
    isnull(nei.vl_total_nota_entr_item,0)  as vl_total_nota_entr_item, -- total
    isnull(nei.pc_icms_nota_entrada,0)     as pc_icms_nota_entrada, -- %icm
    isnull(nei.pc_ipi_nota_entrada,0)      as pc_ipi_nota_entrada, -- %ipi
    isnull(pci.cd_pedido_venda,0)          as cd_pedido_venda -- pedido venda
  from  Nota_Entrada ne
    left outer join  fornecedor f on	ne.cd_fornecedor = f.cd_fornecedor
    left outer join  nota_entrada_item nei on ne.cd_nota_entrada = nei.cd_nota_entrada and
           	                              ne.cd_fornecedor = nei.cd_fornecedor
    left outer join  operacao_fiscal opf on ne.cd_operacao_fiscal = opf.cd_operacao_fiscal
    left outer join  pedido_compra_item pci on nei.cd_pedido_compra = pci.cd_pedido_compra and
	                                       nei.cd_item_pedido_compra = pci.cd_item_pedido_compra	
    left outer join produto_custo pc on nei.cd_produto = pc.cd_produto
    left outer join materia_prima mp on isnull(pci.cd_materia_prima, isnull(pc.cd_mat_prima,0)) = mp.cd_mat_prima        
  where ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and 
    mp.cd_mat_prima is not null and
    isnull(opf.ic_comercial_operacao,'N') = 'S' and
    pci.cd_pedido_compra is not null
  order by
    f.nm_fantasia_fornecedor,
    ne.cd_nota_entrada,
    pci.cd_pedido_compra,
    pci.cd_item_pedido_compra

