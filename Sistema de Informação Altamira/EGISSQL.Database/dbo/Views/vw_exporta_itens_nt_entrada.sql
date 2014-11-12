
CREATE VIEW vw_exporta_itens_nt_entrada
--vw_exporta_itens_nt_entrada
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2003
--Autor(es)		: Alexandre Del Soldato
--Banco de Dados	: EGISSQL
--Objetivo		: Exportação de Itens da Nota Fiscal de Entrada
--Data			: 20/12/2003
---------------------------------------------------
as

select

  'NFE' + cast(ne.cd_nota_entrada as varchar) + '_' +
  cast(ne.cd_fornecedor as varchar) + '_' +
  cast(ne.cd_serie_nota_fiscal as varchar) + '_' +
  cast(ne.cd_operacao_fiscal as varchar) as 'IDENTIFICADOR_CONTROLE',
  1 as cd_tipo_operacao_fiscal,

  ne.dt_nota_entrada		as 'DATA_EMISSAO',
--  cf.cd_classificacao_fiscal    as 'CLASSIFICACAO',

--  nei.cd_produto                as 'CODIGO_PRODUTO',
  p.nm_fantasia_produto as 'CODIGO_PRODUTO',

  nei.qt_item_nota_entrada      as 'QUANTIDADE',
  nei.vl_total_nota_entr_item	as 'VALOR_TOTAL',
  nei.cd_situacao_tributaria	as 'SITUACAO',
  nei.cd_item_nota_entrada	as 'NUMERO_ORDEM',
  nei.vl_bipi_nota_entrada      as 'VALOR_BASE_IPI',
  nei.vl_ipi_nota_entrada	as 'VALOR_IPI',
  nei.vl_ipiisen_nota_entrada	as 'VALOR_ISENTAS_IPI',
  nei.vl_ipiout_nota_entrada	as 'VALOR_OUTRAS_IPI',
  nei.pc_ipi_nota_entrada	as 'ALIQUOTA_IPI',
  nei.vl_bicms_nota_entrada	as 'BASE_CALCULO_ICMS',
  nei.vl_bicms_nota_entrada	as 'BASE_ICMS_TRIBUTARIA',
  nei.pc_icms_nota_entrada	as 'ALIQUOTA_ICMS',
  nei.pc_desc_nota_entrada	as 'VALOR_DESCONTO',
  um.cd_unidade_inst_norma_srf  as 'SITUCAO_TRIBUTARIA'

from
  Nota_Entrada ne

  Left Outer join Nota_Entrada_Item nei
        on nei.cd_nota_entrada = ne.cd_nota_entrada and
           nei.cd_fornecedor = ne.cd_fornecedor and
           nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
           nei.cd_operacao_fiscal = ne.cd_operacao_fiscal

  Left Outer join Produto p
        on p.cd_produto = nei.cd_produto

--  Left outer join classificacao_fiscal cf
--	on nsi.cd_classificacao_fiscal = cf.cd_classificacao_fiscal

  Left outer join Unidade_Medida um
	on nei.cd_unidade_medida = um.cd_unidade_medida

union all

select
  IDENTIFICADOR_CONTROLE,
  cd_tipo_operacao_fiscal,
  DATA_EMISSAO,
  CODIGO_PRODUTO,
  QUANTIDADE,
  VALOR_TOTAL,
  SITUACAO,
  NUMERO_ORDEM,
  VALOR_BASE_IPI,
  VALOR_IPI,
  VALOR_ISENTAS_IPI,
  VALOR_OUTRAS_IPI,
  ALIQUOTA_IPI,
  BASE_CALCULO_ICMS,
  BASE_ICMS_TRIBUTARIA,
  ALIQUOTA_ICMS,
  VALOR_DESCONTO,
  SITUCAO_TRIBUTARIA
from
  vw_exporta_itens_nota_fiscal
where
  cd_tipo_operacao_fiscal = 1 -- ENTRADAS

