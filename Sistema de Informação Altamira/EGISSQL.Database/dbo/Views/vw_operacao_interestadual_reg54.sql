-- ATENÇÃO!! Quando alterar esta view não esqueça
-- de alterar também a procedure "pr_operacao_interestadual"

CREATE      view vw_operacao_interestadual_reg54 as

select distinct

  ns.sg_estado_nota_saida,
  ns.dt_nota_saida,
  ns.cd_nota_saida,
  vw.cd_cnpj                            as 'CNPJ',
  IsNull(snf.cd_modelo_serie_nota,'01') as 'Modelo',
  IsNull(snf.sg_serie_nota_fiscal,'1')  as 'Serie',
  nsi.cd_nota_saida                     as 'Numero',
  opf.cd_mascara_operacao               as 'CFOP',
  nsi.cd_situacao_tributaria            as 'CST',
  IsNull( nsi.cd_mascara_produto, '999999999' ) as 'CodigoProduto',

  SUM( round( nsi.qt_item_nota_saida, 3 ) )     as 'Quantidade',
  SUM( round(((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) -
             ((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) * IsNull(nsi.pc_icms_desc_item,0)/100)) +
             IsNull(nsi.vl_frete_item,0), 2 ) ) as 'ValorProduto',
  SUM( round(nsi.vl_base_icms_item, 2 ) )       as 'BaseCalculoICMS',
  SUM( round(nsi.vl_bc_subst_icms_item, 2 ) )   as 'BaseICMSSubstituicao',
  SUM( round(IsNull(nsi.vl_ipi,0) +
             IsNull(nsi.vl_ipi_corpo_nota_saida,0), 2 ) ) as 'ValorIPI',
  MAX( round( nsi.pc_icms, 2 ) )                as 'Aliquota'

from
  nota_saida ns
  left outer join serie_nota_fiscal snf
  on snf.cd_serie_nota_fiscal = ns.cd_serie_nota
  , nota_saida_item nsi
  , operacao_fiscal opf
  , vw_Destinatario_Rapida vw
where
  ns.sg_estado_nota_saida <> 'EX' and
  ns.cd_status_nota <> 7
  and
  nsi.cd_nota_saida = ns.cd_nota_saida
  and
  opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
  opf.ic_opinterestadual_op_fis = 'S' and
  IsNull(opf.ic_servico_operacao,'N') <> 'S'
  and
  vw.cd_destinatario = ns.cd_cliente and
  vw.cd_tipo_destinatario = ns.cd_tipo_destinatario

group by

  ns.sg_estado_nota_saida,
  ns.dt_nota_saida,
  ns.cd_nota_saida,
  vw.cd_cnpj,
  IsNull(snf.cd_modelo_serie_nota,'01'),
  IsNull(snf.sg_serie_nota_fiscal,'1'),
  nsi.cd_nota_saida,
  opf.cd_mascara_operacao,
  nsi.cd_situacao_tributaria,
  IsNull( nsi.cd_mascara_produto, '999999999' )


