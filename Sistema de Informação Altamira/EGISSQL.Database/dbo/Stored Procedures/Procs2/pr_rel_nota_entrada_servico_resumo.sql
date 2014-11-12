
--pr_rel_nota_entrada_servico_resumo
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Rafael M. Santiago
--Banco de Dados	: EGISSQL
--Objetivo		: Relatório de Notas Fiscais de Entrada de serviço
--Data			: 12/09/03
--Alteração		: 24/10/2003 - Modificação no tipo de filtro p/ CFOP - ELIAS
--Desc. Alteração	: <Descrição da Alteração>
---------------------------------------------------



CREATE PROCEDURE pr_rel_nota_entrada_servico_resumo

@dt_inicial datetime,
@dt_final   datetime

AS


SELECT
	f.nm_fantasia_fornecedor,
	ne.cd_nota_entrada,
	ne.dt_nota_entrada,
	ne.dt_receb_nota_entrada,
	opf.cd_mascara_operacao,
	opf.cd_tributacao,
	ISNULL(ne.cd_rem,0)                    AS cd_rem,
	ISNULL(ne.vl_bicms_nota_entrada,0)     AS vl_bicms_nota_entrada, -- BaseICMS
	ISNULL(ne.vl_icms_nota_entrada,0)      AS vl_icms_nota_entrada, -- ValorICMS
	ISNULL(ne.vl_bsticm_nota_entrada,0)    AS vl_bsticm_nota_entrada, -- Base Subst
	ISNULL(ne.vl_sticm_nota_entrada,0)     AS vl_sticm_nota_entrada, -- Valor Subst
	ISNULL(ne.vl_prod_nota_entrada,0)      AS vl_prod_nota_entrada, -- Total Prod
	ISNULL(ne.vl_frete_nota_entrada,0)     AS vl_frete_nota_entrada, -- Valor Frete
	ISNULL(ne.vl_seguro_nota_entrada,0)    AS vl_seguro_nota_entrada, -- Valor Seguro
	ISNULL(ne.vl_despac_nota_entrada,0)    AS vl_despac_nota_entrada, -- Outras Desp
	ISNULL(ne.vl_ipi_nota_entrada,0)       AS vl_ipi_nota_entrada, -- Valor IPI
	ISNULL(ne.vl_total_nota_entrada,0)     AS vl_total_nota_entrada, -- Total Nota
-- ITENS
	dbo.fn_mascara_produto(nei.cd_produto) AS cd_mascara_produto,
	nei.nm_produto_nota_entrada,
	nei.qt_item_nota_entrada,
	ISNULL(nei.qt_pesliq_nota_entrada,0)   AS qt_pesliq_nota_entrada, -- Peso Liquido
 	ISNULL(nei.vl_item_nota_entrada,0)     AS vl_item_nota_entrada, -- Unitário
	ISNULL(nei.vl_total_nota_entr_item,0)  AS vl_total_nota_entr_item, -- Total
	ISNULL(nei.pc_icms_nota_entrada,0)     AS pc_icms_nota_entrada, -- %ICM
	ISNULL(nei.pc_ipi_nota_entrada,0)      AS pc_ipi_nota_entrada, -- %IPI
	ISNULL(pci.cd_pedido_venda,0)          AS cd_pedido_venda -- Pedido Venda
	
FROM 
	Nota_Entrada ne
	LEFT OUTER JOIN
	Fornecedor f
	ON
	ne.cd_fornecedor = f.cd_fornecedor
	LEFT OUTER JOIN
	Nota_Entrada_Item nei
	ON
	ne.cd_nota_entrada = nei.cd_nota_entrada
	LEFT OUTER JOIN
	Operacao_Fiscal opf
	ON
	ne.cd_operacao_fiscal = opf.cd_operacao_fiscal
	LEFT OUTER JOIN
	Pedido_Compra_Item pci
	ON
	nei.cd_item_pedido_compra = pci.cd_item_pedido_compra

WHERE 
        opf.ic_servico_operacao = 'S' and
	ne.dt_receb_nota_entrada between @dt_inicial and @dt_final
GROUP BY
	ne.cd_nota_entrada,
	f.nm_fantasia_fornecedor,
	ne.dt_nota_entrada,
	ne.dt_receb_nota_entrada,
	opf.cd_mascara_operacao,
	opf.cd_tributacao,
	ne.cd_rem,
	ne.vl_bicms_nota_entrada,
	ne.vl_icms_nota_entrada,
	ne.vl_bsticm_nota_entrada,
	ne.vl_sticm_nota_entrada,
	ne.vl_prod_nota_entrada,
	ne.vl_frete_nota_entrada,
	ne.vl_seguro_nota_entrada,
	ne.vl_despac_nota_entrada,
	ne.vl_ipi_nota_entrada,
	ne.vl_total_nota_entrada,
	nei.cd_produto,
	nei.nm_produto_nota_entrada,
	nei.qt_item_nota_entrada,
	nei.qt_pesliq_nota_entrada,
	nei.vl_item_nota_entrada,
	nei.vl_total_nota_entr_item,
	nei.pc_icms_nota_entrada,
	nei.pc_ipi_nota_entrada,
	pci.cd_pedido_venda
