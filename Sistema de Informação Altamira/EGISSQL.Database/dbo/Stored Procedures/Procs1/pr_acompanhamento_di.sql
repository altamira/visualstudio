
CREATE  PROCEDURE pr_acompanhamento_di
  @nm_di text
AS

select 
	 di.nm_di           as 'DI',
	 i.nm_invoice       as 'Invoice',
	 f.nm_razao_social  as 'Empresa',
	 di.nm_bl_awb       as 'MAWB',
	 di.nm_h_bl_awb     as 'HAWB',
   di.nm_ref_despachante_di as 'NumeroRegistro',
	 tf.nm_tipo_frete + ' - ' + tc.nm_termo_comercial as 'Frete',
	 p.nm_fantasia_produto as 'CodigoProduto',
   RTrim(p.nm_produto)                   as 'DescricaoProduto',
	 IsNull(dii.qt_embarque,0)       as 'Quantidade',
   IsNull(dii.vl_produto_moeda_origem,0) as 'PrecoUnit',
	 m.sg_moeda                      as 'Moeda',
   IsNull(dii.vl_total_moeda_origem,0)   as 'PrecoTotal',
   IsNull(dii.qt_peso_bruto_item_di,0)   as 'Peso',
	 um.sg_unidade_medida            as 'Unidade',
	 IsNull((dii.qt_peso_bruto_item_di * dii.qt_embarque),0) as 'PesoTotal',
	 oi.nm_origem_importacao         as 'Origem',
	 cf.cd_mascara_classificacao     as 'NCM',
	 IsNull(dii.pc_di_item_ii,0)     as 'II',
	 IsNull(dii.vl_ii_item_di,0)     as 'ValorII',
	 IsNull(dii.pc_di_item_ipi,0)   as 'IPI',
	 IsNull(dii.pc_di_item_icms,0)   as 'ICMS',
	 Case when dii.pc_red_icms_item_di >=100
		  then 0
		  else IsNull(dii.pc_red_icms_item_di,0) end as 'RedICMS',
	 IsNull(dii.vl_icms_item_di,0) as 'ValorICMS',
	 IsNull(dii.vl_total_icms_item_di,0) as 'TotalICMS',
   IsNull(dii.vl_pis_item_di,0) as 'ValorPIS',
	 IsNull(dii.vl_total_pis_item_di,0) as 'ValorTotalPIS',
	 IsNull(dii.vl_cof_item_di,0) as 'ValorCofins',
	 IsNull(dii.vl_total_cof_item_di,0) as 'ValorTotalCofins',
	 IsNull(dii.vl_sis_item_di,0) as 'ValorSis',
	 IsNull(dii.vl_total_sis_item_di,0) as 'ValorTotalSis',
   IsNull(dii.pc_di_item_pis,0) as 'AliqPIS',
	 IsNull(dii.pc_di_item_cof,0) as 'AliqCofins',
	 isNull((dii.vl_total_moeda_destino * dii.pc_di_item_ipi),0) as 'ValorIPI',
	 IsNull(vl_despesa_frete_di,0) as 'ValorFrete',
	 IsNull(vl_embalagem_di,0) as 'ValorEmbalagem',
	 di.vl_moeda_di as 'Cotacao'
from di_item dii with (nolock) 
	left outer join di di             on di.cd_di=dii.cd_di
	left outer join invoice i         on i.cd_invoice=dii.cd_invoice
	left outer join tipo_frete tf     on tf.cd_tipo_frete=di.cd_tipo_frete
	left outer join produto p         on p.cd_produto=dii.cd_produto
	left outer join fornecedor f      on f.cd_fornecedor=di.cd_fornecedor
  left outer join produto_fiscal pf       on pf.cd_produto=p.cd_produto
  left outer join classificacao_fiscal cf on pf.cd_classificacao_fiscal=cf.cd_classificacao_fiscal
	left outer join moeda m           on m.cd_moeda=di.cd_moeda_di
	left outer join unidade_medida um on um.cd_unidade_medida=p.cd_unidade_medida
	left outer join origem_importacao oi on oi.cd_origem_importacao=dii.cd_origem_importacao
  left outer join termo_comercial tc on tc.cd_termo_comercial = di.cd_termo_comercial
where
   di.nm_di like @nm_di

order by dii.cd_origem_importacao, cf.cd_classificacao_fiscal, p.nm_fantasia_produto

