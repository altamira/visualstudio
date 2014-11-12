

CREATE  VIEW vw_exporta_nota_fiscal_entrada
--vw_exporta_nota_fiscal_entrada
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2003
--Autor(es)		: Alexandre Del Soldato
--Banco de Dados	: EGISSQL
--Objetivo		: Exportação da Nota Fiscal de Saída
--Data			: 15/12/2003
---------------------------------------------------
as

select distinct

  'NFE' + cast(ne.cd_nota_entrada as varchar) + '_' +
  cast(ne.cd_fornecedor as varchar) + '_' +
  cast(ne.cd_serie_nota_fiscal as varchar) + '_' +
  cast(ne.cd_operacao_fiscal as varchar) as 'IDENTIFICADOR_CONTROLE',
  1 as 'cd_tipo_operacao_fiscal',

  ne.cd_fornecedor as 'CODIGO',

  Case
    When isnull(vw.cd_pais,1) = 1 then
      case when vw.cd_tipo_pessoa = 1 then
        cast(dbo.fn_formata_mascara('00.000.000/0000-00',vw.cd_cnpj) as varchar(18))
      else
        cast(dbo.fn_formata_mascara('000.000.000-00',vw.cd_cnpj) as varchar(18))
      end     
    else 
      case when vw.cd_tipo_pessoa = 1 then
        cast( vw.cd_destinatario + 40000 as varchar(18) )
      else
        cast( vw.cd_destinatario + 50000 as varchar(18) )
      end
  end as 'CNPJ',

  case when rtrim(ofi.cd_mascara_operacao) = ''
       then
         null
       else rtrim(ofi.cd_mascara_operacao) + '.' +
        (case when len(cast(ofi.cd_destinacao_produto as varchar)) > 1 then '' else '0' end) +
        cast(ofi.cd_destinacao_produto as varchar)
       end as 'NATUREZA',

  ne.cd_nota_entrada		as 'NUMERO_NF_INICO',
  ne.cd_nota_entrada		as 'NUMERO_NF_FINAL',
  '1'			        as 'MODELO',
  'NFE'				as 'ESPECIE_DOCUMENTO',
--  ne.cd_serie_nota_fiscal	as 'SERIE',
  '1'                           as 'SERIE', 
  ne.dt_nota_entrada		as 'DATA_ENTRADA',
  ne.dt_nota_entrada		as 'DATA_EMISSAO',
  e.sg_estado				as 'ESTADO_DESTINO',

  Case
    When isnull(vw.cd_pais,1) = 1 then isnull(ne.sg_estado, estdest.sg_estado)
    else 'EX'
  end as 'ESTADO_ORIGEM',

  ne.vl_total_nota_entrada	as 'VALOR_TOTAL',

  isnull(nei.pc_icms_nota_entrada,0) as 'ALIQUOTA',
  sum(IsNull(nei.vl_bicms_nota_entrada,0)) as 'BASE_CALCULO',
  sum(IsNull(nei.vl_icms_nota_entrada,0))	 as 'VALOR_ICMS',

  null				as 'VALOR_ISENTAS_ICMS',
  null				as 'VALOR_OUTROS_ICMS',  
  (ne.vl_total_nota_entrada - ne.vl_prod_nota_entrada) as 'VALOR_RELATIVO',

  ne.vl_servico_nota_entrada as 'BASE_CALCULO_1',
  ne.vl_irrf_nota_entrada    as 'VALOR_PRIMEIRO',

  ne.vl_servico_nota_entrada as 'BASE_CALCULO_2',
  vl_iss_nota_entrada        as 'VALOR_SEGUNDO',

  0	as 'ACRESCIMO',
  ne.vl_bipi_nota_entrada	as 'BASE_IPI',
  ne.vl_ipi_nota_entrada	as 'VALOR_IPI',
  null				as 'VALOR_ISENTAS_IPI',
  null				as 'VALOR_OUTROS_IPI',
  null			        as 'VALOR_REDUCAO_IPI',
  case when ne.cd_tipo_destinatario = 1 then (Select top 1 ic_contrib_icms_cliente from Cliente)
  else 'N'
  end				as 'INDICADOR_CONTRIBUI',
  null		as 'CODIGO_FISCAL',
  'N'				as 'INDICADOR_CANCELAMENTO',
  ''				as 'OBSERVACAO',
--  CAST(ISNULL(ne.ds_obs_compl_nota_entrada,'') AS VARCHAR(50)) as 'OBSERVACAO',
  (Select top 1 nep.dt_parcela_nota_entrada 
    from Nota_Entrada_Parcela nep where nep.cd_nota_entrada = ne.cd_nota_entrada) as 'DATA_VENCIMENTO',
  null				as 'CONTA_DEVEDORA',

  null			 	as 'CONTA_CREDORA',
  ''         			as 'COMPLEMENTO_HISTORICO_DEBITO',
  null				as 'COMPLEMENTO_HISTORICO_CREDITO',

  MAX( IsNull(cf.ic_base_reduzida,'N') ) as 'INDICADOR'

from
  Nota_Entrada ne

  inner join vw_Destinatario_Rapida vw
    on vw.cd_destinatario = ne.cd_fornecedor and
       vw.cd_tipo_destinatario = ne.cd_tipo_destinatario

  inner join Operacao_Fiscal ofi
    on ofi.cd_operacao_fiscal = ne.cd_operacao_fiscal

  Left  Outer Join Estado estdest
    on estdest.cd_estado = vw.cd_estado

  Left Outer join Nota_Entrada_Item nei
        on ne.cd_nota_entrada = nei.cd_nota_entrada

  Left outer join classificacao_fiscal cf
	on nei.cd_classificacao_fiscal = cf.cd_classificacao_fiscal

  , egisadmin.dbo.empresa emp
  , Estado E

where
  emp.cd_empresa = dbo.fn_empresa()
  and
  e.cd_estado = emp.cd_estado
  and
  isnull(nei.pc_icms_nota_entrada,0) = isnull( (Select MAX(pc_icms_nota_entrada)
                                                From Nota_Entrada_Item
                                                Where cd_nota_entrada = nei.cd_nota_entrada and
                                                      cd_fornecedor = nei.cd_fornecedor and
                                                      cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                      cd_operacao_fiscal = nei.cd_operacao_fiscal), 0)
group by

  cast(ne.cd_nota_entrada as varchar) + '_' +
  cast(ne.cd_fornecedor as varchar) + '_' +
  cast(ne.cd_serie_nota_fiscal as varchar) + '_' +
  cast(ne.cd_operacao_fiscal as varchar),

  ne.cd_fornecedor,

  Case
    When isnull(vw.cd_pais,1) = 1 then
      case when vw.cd_tipo_pessoa = 1 then
        cast(dbo.fn_formata_mascara('00.000.000/0000-00',vw.cd_cnpj) as varchar(18))
      else
        cast(dbo.fn_formata_mascara('000.000.000-00',vw.cd_cnpj) as varchar(18))
      end     
    else 
      case when vw.cd_tipo_pessoa = 1 then
        cast( vw.cd_destinatario + 40000 as varchar(18) )
      else
        cast( vw.cd_destinatario + 50000 as varchar(18) )
      end
  end,

  ofi.cd_mascara_operacao,
  ofi.cd_destinacao_produto,

  ne.cd_nota_entrada,
  ne.cd_nota_entrada,
  ne.cd_serie_nota_fiscal,
  ne.dt_nota_entrada,
  ne.dt_nota_entrada,
  e.sg_estado,

  Case
    When isnull(vw.cd_pais,1) = 1 then isnull(ne.sg_estado, estdest.sg_estado)
    else 'EX'
  end,

  nei.pc_ipi_nota_entrada,
  ne.vl_total_nota_entrada,

  isnull(nei.pc_icms_nota_entrada,0),

  (ne.vl_total_nota_entrada),
  ne.vl_prod_nota_entrada,

  ne.vl_servico_nota_entrada,
  ne.vl_irrf_nota_entrada,
  ne.vl_iss_nota_entrada,

  ne.vl_bipi_nota_entrada,
  ne.vl_ipi_nota_entrada,
  ne.cd_tipo_destinatario,
  ne.cd_operacao_fiscal
--  ne.ds_obs_compl_nota_entrada	as 'OBSERVACAO',

union all

Select
  IDENTIFICADOR_CONTROLE,
  cd_tipo_operacao_fiscal,
  CODIGO,
  CNPJ,
  NATUREZA,
  NUMERO_NF_INICO,
  NUMERO_NF_FINAL,
  MODELO,
  ESPECIE_DOCUMENTO,
  SERIE,
  DATA_ENTRADA,
  DATA_EMISSAO,
  ESTADO_DESTINO,
  ESTADO_ORIGEM,
  VALOR_TOTAL,
  ALIQUOTA,
  BASE_CALCULO,
  VALOR_ICMS,
  VALOR_ISENTAS_ICMS,
  VALOR_OUTROS_ICMS,
  VALOR_RELATIVO,
  BASE_CALCULO_1,
  VALOR_PRIMEIRO,
  BASE_CALCULO_2,
  VALOR_SEGUNDO,
  ACRESCIMO,
  BASE_IPI,
  VALOR_IPI,
  VALOR_ISENTAS_IPI,
  VALOR_OUTROS_IPI,
  VALOR_REDUCAO_IPI,
  INDICADOR_CONTRIBUI,
  CODIGO_FISCAL,
  INDICADOR_CANCELAMENTO,
  OBSERVACAO,
  DATA_VENCIMENTO,
  CONTA_DEVEDORA,
  CONTA_CREDORA,
  COMPLEMENTO_HISTORICO_DEBITO,
  COMPLEMENTO_HISTORICO_CREDITO,
  INDICADOR 
from
  vw_exporta_nota_fiscal
where
  cd_tipo_operacao_fiscal = 1 -- ENTRADAS

