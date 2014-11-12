-- ATENÇÃO!! Quando alterar esta view não esqueça
-- de alterar também a procedure "pr_operacao_interestadual"

CREATE     view vw_operacao_interestadual_reg75 as

select distinct
  ns.sg_estado_nota_saida,
  ns.dt_nota_saida,
  IsNull( nsi.cd_mascara_produto, '999999999' ) as 'CodigoProduto',
  dbo.fn_descricao_produto_op_interestadual( nsi.cd_mascara_produto, nsi.nm_produto_item_nota ) as 'Descricao',
  dbo.fn_unidade_produto_op_interestadual( nsi.cd_mascara_produto, um.sg_unidade_medida ) as 'UnidadeMedida',

  MAX( IsNull( cf.cd_mascara_classificacao, '00000000' ) ) as 'CodigoNCM',
  MAX( nsi.cd_situacao_tributaria )             as 'SituacaoTributaria',
  round( MAX( nsi.pc_ipi ), 2 )                 as 'AliquotaIPI',
  round( MAX( nsi.pc_icms ), 2 )                as 'AliquotaICMS',
  round( MAX( nsi.pc_reducao_icms ), 2 )        as 'ReducaoICMS',
  round( MAX( nsi.vl_bc_subst_icms_item ), 2 )  as 'BaseICMSSubstituicao'

from
  nota_saida ns
  , nota_saida_item nsi

  left outer join classificacao_fiscal cf
  on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal

  left outer join unidade_medida um
  on um.cd_unidade_medida = nsi.cd_unidade_medida

  , operacao_fiscal opf

where
  ns.sg_estado_nota_saida <> 'EX' and
  ns.cd_status_nota <> 7
  and
  nsi.cd_nota_saida = ns.cd_nota_saida
  and
  opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
  opf.ic_opinterestadual_op_fis = 'S' and
  IsNull(opf.ic_servico_operacao,'N') <> 'S'

group by
  ns.sg_estado_nota_saida,
  ns.dt_nota_saida,
  IsNull( nsi.cd_mascara_produto, '999999999' ),
  dbo.fn_descricao_produto_op_interestadual( nsi.cd_mascara_produto, nsi.nm_produto_item_nota ),
  dbo.fn_unidade_produto_op_interestadual( nsi.cd_mascara_produto, um.sg_unidade_medida )

