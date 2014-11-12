
CREATE VIEW vw_exporta_aliquota_nt_entrada
--vw_exporta_aliquota_nt_entrada
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2003
--Autor(es)		: Alexandre Del Soldato
--Banco de Dados	: EGISSQL
--Objetivo		: Exportação de Aliquotas Adicionais da Nota Fiscal de Entrada
--Data			: 20/12/2003
---------------------------------------------------
as

select

  'NFE' + cast(ne.cd_nota_entrada as varchar) + '_' +
  cast(ne.cd_fornecedor as varchar) + '_' +
  cast(ne.cd_serie_nota_fiscal as varchar) + '_' +
  cast(ne.cd_operacao_fiscal as varchar)   as 'IDENTIFICADOR_CONTROLE',
  1 as cd_tipo_operacao_fiscal,

  ne.dt_nota_entrada		                   as 'DATA_EMISSAO',
  IsNull(nei.pc_icms_nota_entrada,0)	     as 'ALIQUOTA_ICMS',
  sum(IsNull(nei.vl_bicms_nota_entrada,0)) as 'BASE_ICMS',
  sum(IsNull(nei.vl_icms_nota_entrada,0))	 as 'VALOR_ICMS'

from
  Nota_Entrada ne

  Left Outer join Nota_Entrada_Item nei
        on ne.cd_nota_entrada = nei.cd_nota_entrada and
           ne.cd_fornecedor = nei.cd_fornecedor and
           ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
           ne.cd_operacao_fiscal = nei.cd_operacao_fiscal

where
   IsNull(nei.pc_icms_nota_entrada,0) <> ( Select isnull( MAX(pc_icms_nota_entrada), 0 )
                                           From Nota_Entrada_Item 
                                           Where cd_nota_entrada = nei.cd_nota_entrada and
                                                 cd_fornecedor = nei.cd_fornecedor and
                                                 cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                 cd_operacao_fiscal = nei.cd_operacao_fiscal )
group by
  'NFE' + cast(ne.cd_nota_entrada as varchar) + '_' +
  cast(ne.cd_fornecedor as varchar) + '_' +
  cast(ne.cd_serie_nota_fiscal as varchar) + '_' +
  cast(ne.cd_operacao_fiscal as varchar),

  ne.dt_nota_entrada,	
  IsNull(nei.pc_icms_nota_entrada,0)

union all

select
  IDENTIFICADOR_CONTROLE,
  cd_tipo_operacao_fiscal,
  DATA_EMISSAO,
  ALIQUOTA_ICMS,
  BASE_ICMS,
  VALOR_ICMS
from
  vw_exporta_aliquota_nota_fiscal
where
  cd_tipo_operacao_fiscal = 1 -- ENTRADAS

