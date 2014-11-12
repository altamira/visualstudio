
create view vw_sintegra_entrada_reg75 as

select distinct
  uf.sg_estado                                             as sg_estado_nota_saida,
  ne.dt_nota_entrada                                       as dt_nota_saida,
  ne.cd_nota_entrada                                       as cd_nota_saida,
  ne.dt_receb_nota_entrada                                 as 'DataEmissaoRecto',
  IsNull(p.cd_mascara_produto, '999999999' )               as 'CodigoProduto',
  dbo.fn_descricao_produto_op_interestadual(p.cd_mascara_produto, nei.nm_produto_nota_entrada) as 'Descricao',
  dbo.fn_unidade_produto_op_interestadual(p.cd_mascara_produto, um.sg_unidade_medida ) as 'UnidadeMedida',
  MAX( IsNull( cf.cd_mascara_classificacao, '00000000' ) ) as 'CodigoNCM',
  case when (isnull(max(nei.cd_situacao_tributaria),'')='') then
    '000'
  else
    max(nei.cd_situacao_tributaria)
  end                                                      as 'SituacaoTributaria',
  round( MAX( nei.pc_ipi_nota_entrada ), 2 )               as 'AliquotaIPI',
  round( MAX( nei.pc_icms_nota_entrada ), 2 )              as 'AliquotaICMS',
  round( MAX( nei.pc_icms_red_nota_entrada ), 2 )          as 'ReducaoICMS',
  cast(0 as decimal(25,2))                                 as 'BaseICMSSubstituicao'
from
  nota_entrada_item nei
inner join
  nota_entrada ne
on
  ne.cd_nota_entrada = nei.cd_nota_entrada and
  ne.cd_fornecedor = nei.cd_fornecedor and
  ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
left outer join
  vw_destinatario_rapida vw
on
  vw.cd_tipo_destinatario = ne.cd_tipo_destinatario and
  vw.cd_destinatario = ne.cd_fornecedor
left outer join
  estado uf
on
  uf.cd_estado = vw.cd_estado and
  uf.cd_pais = vw.cd_pais    
inner join
  operacao_fiscal opf
on
  opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
left outer join
  produto p
on
  p.cd_produto = nei.cd_produto
left outer join
  unidade_medida um
on
  um.cd_unidade_medida = nei.cd_unidade_medida
left outer join
  classificacao_fiscal cf
on
  cf.cd_classificacao_fiscal = nei.cd_classificacao_fiscal
where
  IsNull(opf.ic_servico_operacao,'N') <> 'S'
group by
  uf.sg_estado,
  ne.dt_nota_entrada,
  ne.cd_nota_entrada,
  ne.dt_receb_nota_entrada,
  IsNull(p.cd_mascara_produto, '999999999' ),
  dbo.fn_descricao_produto_op_interestadual(p.cd_mascara_produto, nei.nm_produto_nota_entrada),
  dbo.fn_unidade_produto_op_interestadual(p.cd_mascara_produto, um.sg_unidade_medida )

