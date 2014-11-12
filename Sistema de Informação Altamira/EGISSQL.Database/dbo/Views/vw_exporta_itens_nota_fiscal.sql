
CREATE VIEW vw_exporta_itens_nota_fiscal
--vw_exporta_itens_nota_fiscal
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2003
--Autor(es)		: Alexandre Del Soldato
--Banco de Dados	: EGISSQL
--Objetivo		: Exportação de Itens da Nota Fiscal de Saída
--Data			: 15/12/2003
--            22/03/2004 - Usar o nome fantasia ao invés do código do produto - Eduardo    
---------------------------------------------------
as

select

  'NFS' + cast(ns.cd_nota_saida as varchar(10))	as 'IDENTIFICADOR_CONTROLE',
  ns.cd_tipo_operacao_fiscal,

  ns.dt_nota_saida		as 'DATA_EMISSAO',
--  cf.cd_classificacao_fiscal    as 'CLASSIFICACAO',

--  nsi.cd_produto                as 'CODIGO_PRODUTO',
  p.nm_fantasia_produto as 'CODIGO_PRODUTO',

  nsi.qt_item_nota_saida        as 'QUANTIDADE',
  nsi.vl_total_item		as 'VALOR_TOTAL',
  nsi.cd_situacao_tributaria	as 'SITUACAO',
  nsi.cd_item_nota_saida	as 'NUMERO_ORDEM',
  nsi.vl_base_ipi_item	        as 'VALOR_BASE_IPI',
  nsi.vl_ipi			as 'VALOR_IPI',
  nsi.vl_ipi_isento_item	as 'VALOR_ISENTAS_IPI',
  nsi.vl_ipi_outros_item	as 'VALOR_OUTRAS_IPI',
  nsi.pc_ipi			as 'ALIQUOTA_IPI',
  nsi.vl_base_icms_item		as 'BASE_CALCULO_ICMS',
  nsi.vl_bc_subst_icms_item 	as 'BASE_ICMS_TRIBUTARIA',
  nsi.pc_icms			as 'ALIQUOTA_ICMS',
  nsi.pc_desconto_item		as 'VALOR_DESCONTO',
  um.cd_unidade_inst_norma_srf  as 'SITUCAO_TRIBUTARIA'

from
  Nota_Saida ns

  Left Outer join Nota_Saida_Item nsi
        on ns.cd_nota_saida = nsi.cd_nota_saida

  Left Outer join Produto p
        on p.cd_produto = nsi.cd_produto

--  Left outer join classificacao_fiscal cf
--	on nsi.cd_classificacao_fiscal = cf.cd_classificacao_fiscal

  Left outer join Unidade_Medida um
	on nsi.cd_unidade_medida = um.cd_unidade_medida

