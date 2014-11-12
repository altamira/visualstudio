
CREATE PROCEDURE pr_gera_livro_registro_saida
@dt_inicial datetime,
@dt_final datetime

as

/* ELIAS - Tabela Temporária com os Registros não modificados
  que podem ser reprocessados */
select 
  distinct 
  n.cd_nota_saida
into
  #NF_Reprocessada
from
  Nota_Saida n
left outer join
  Nota_Saida_Registro nsr  
on
  nsr.cd_nota_saida = n.cd_nota_saida
where
  isnull(nsr.ic_manual_nota_saida_reg,'N') = 'N' and
  isnull(nsr.ic_fiscal_nota_saida_reg,'N') = 'N' and
  n.dt_nota_saida between @dt_inicial and @dt_final

/* ELIAS - ACRESCENTADO TABELA COM REGISTROS DE NOTAS DE COMPLEMENTO
   QUE NÃO CONTÊM ITENS - 04/07/2003 */
select 
  n.cd_nota_saida		as 'NotaSaida',
  n.cd_num_formulario_nota	as 'Formulario',
  1				as 'ItemNota',
  cast(null as int)		as 'ItemLivro',
  'NFF' 			as 'Especie',
  'UN'  	 		as 'Serie',
  n.dt_nota_saida		as 'Emissao',
  n.sg_estado_nota_saida	as 'UF',
  n.cd_destinacao_produto       as 'Destinacao',
  o.cd_mascara_operacao		as 'CFOP',
  o.cd_operacao_fiscal          as 'CodCFOP',
  cast(null as varchar(20))	as 'ClassContabil',
  o.cd_tributacao		as 'Tributacao',
  isnull(o.ic_contribicms_op_fiscal,'S')			as 'ContrICMS',
  sum(isnull(cast(n.vl_total as decimal(25,2)),0)) 	        as 'VlProduto',
  sum(isnull(cast(n.vl_total as decimal(25,2)),0)) + 
  case when  isnull(o.ic_complemento_op_fiscal,'N') <> 'S' then
   sum(isnull(cast(n.vl_ipi as decimal(25,2)),0)) else 0 end +
--  sum(isnull(cast(n.vl_ipi as decimal(25,2)),0)) +
  sum(isnull(cast(n.vl_frete as decimal(25,2)),0)) +
  sum(isnull(cast(n.vl_seguro as decimal(25,2)),0)) +
  sum(isnull(cast(n.vl_desp_acess as decimal(25,2)),0))         as 'VlContabil',
  sum(isnull(cast(n.vl_bc_icms as decimal(25,2)),0))		as 'BCICMS',
  sum(isnull(cast(n.vl_bc_ipi as decimal(25,2)),0))      	as 'BCIPI',
  cast(null as decimal(25,2))					as 'AliqICMS',
  cast(null as decimal(25,2))					as 'AliqIPI',
  sum(cast(n.vl_ipi as decimal(25,2))) 				as 'IPI',
  sum(cast(n.vl_icms as decimal(25,2)))                		as 'ICMS',
  sum(isnull(cast(n.vl_ipi_obs as decimal(25,2)),0))       	as 'ObsIPI',
  sum(isnull(cast(n.vl_icms_obs as decimal(25,2)),0))		as 'ObsICMS',
  sum(cast(n.vl_frete as decimal(25,2))) 			as 'Frete',
  sum(cast(n.vl_seguro as decimal(25,2))) 			as 'Seguro',
  sum(cast(n.vl_desp_acess as decimal(25,2))) 			as 'DespAcess',
  cast(null as decimal(25,2))                                   as 'DescICMS',
  cast(null as decimal(25,2))    				as 'RedICMS',
  case when (n.cd_status_nota = 7) then 'S' else 'N' end 	as 'Cancelada',
  isnull(o.ic_servico_operacao,'N') 				as 'Servico',
  isnull(n.ic_zona_franca,'N') 					as 'ZonaFranca',
  isnull(ep.ic_resumo_saida,'S') 				as 'Resumo',
  isnull(o.ic_devmp_operacao_fiscal,'N') 			as 'Devolucao',
  o.nm_obs_livro_operacao					as 'MsgObs',
  sum(isnull(cast(n.vl_icms_outros as decimal(25,2)),0)) 	as 'OutrosICMS',
  sum(isnull(cast(n.vl_ipi_outros as decimal(25,2)),0)) 	as 'OutrosIPI',
  'N'								as 'MP66',
  /* ELIAS 18/08/2003 - Campos de Serviço */
  sum(isnull(cast(n.vl_servico as decimal(25,2)),0))		as 'VlServico',
  cast(null as decimal(25,2))					as 'AliqISS',
  sum(isnull(cast(n.vl_iss as decimal(25,2)),0))		as 'ISS',  
  cast(null as int)						as 'CodServico',
  /* ELIAS 17/01/2004 */
  n.cd_serie_nota						as 'CodSerie'
into
  #NF_Sem_Item
from
  Nota_Saida n
inner join
  #NF_Reprocessada nsr
on
  nsr.cd_nota_saida = n.cd_nota_saida
left outer join
  Operacao_Fiscal o
on
  o.cd_operacao_fiscal = n.cd_operacao_fiscal
/* ELIAS 18/11/2003 - FILTRANDO APENAS SAÍDA */
left outer join
  Grupo_Operacao_Fiscal gop
on
  gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
left outer join
  Estado e
on
  e.sg_estado = n.sg_estado_nota_saida and
  e.cd_pais = n.cd_pais  
left outer join
  Estado_Parametro ep
on
  ep.cd_estado = e.cd_estado and
  ep.cd_pais = e.cd_pais
where
  /* ELIAS 18/11/2003 - FILTRANDO APENAS SAÍDA */
  /* Alexandre 05/02/2004 - TIRAR O FILTRO gop.cd_tipo_operacao_fiscal PARA TRAZER TODAS AS NOTAS DE ENTRADA QUE FOI UTILIZADA COMO SAIDA */
--  gop.cd_tipo_operacao_fiscal = 2  and -- SAÍDA
  n.dt_nota_saida between @dt_inicial and @dt_final and
  n.cd_nota_saida not in (select 
                            nsi.cd_nota_saida 
                          from 
                            nota_saida_item nsi
                          where 
                            nsi.cd_nota_saida = n.cd_nota_saida)
group by
  n.cd_nota_saida,
  n.cd_num_formulario_nota,
  n.dt_nota_saida,
  o.cd_mascara_operacao,
  o.cd_operacao_fiscal,
  o.ic_comercial_operacao,
  o.cd_tributacao,
  n.sg_estado_nota_saida,
  n.cd_destinacao_produto,
  o.ic_contribicms_op_fiscal,
  n.cd_status_nota,
  o.ic_servico_operacao,
  n.ic_zona_franca,
  ep.ic_resumo_saida,
  o.ic_devmp_operacao_fiscal,
  o.nm_obs_livro_operacao,
  /* ELIAS 17/01/2004 */
  n.cd_serie_nota,
  o.ic_complemento_op_fiscal

/* ELIAS 24/06/2003 - ARREDONDAMENTO DOS VALORES MONETÁRIOS COM CAST */
select
  /* ELIAS 03/07/2003, trocados os campos de item para cabeçalho para serem listados
      as notas mesmo que não contenham itens (NF de Complemento) */
  n.cd_nota_saida		as 'NotaSaida',
  n.cd_num_formulario_nota	as 'Formulario',
  i.cd_item_nota_saida		as 'ItemNota',
  cast(null as int)		as 'ItemLivro',
  'NFF' 			as 'Especie',
  'UN'  	 		as 'Serie',
  n.dt_nota_saida		as 'Emissao',
  n.sg_estado_nota_saida	as 'UF',
  n.cd_destinacao_produto       as 'Destinacao',
  o.cd_mascara_operacao		as 'CFOP',
  o.cd_operacao_fiscal          as 'CodCFOP',
  cast(null as varchar(20))	as 'ClassContabil',
  /* ELIAS 08/07/2003 */
  isnull(i.cd_tributacao,o.cd_tributacao)			as 'Tributacao',
  isnull(o.ic_contribicms_op_fiscal,'S')			as 'ContrICMS',
  sum(isnull(cast(i.vl_total_item as decimal(25,2)),0)) 	as 'VlProduto',
--  sum(isnull(cast((i.vl_total_item - ((i.vl_total_item * isnull(i.pc_icms_desc_item,0)) / 100)) as decimal(25,2)),0)) + 
  sum(isnull(cast(i.vl_total_item as decimal(25,2)),0)) + 
  sum(isnull(cast(i.vl_ipi as decimal(25,2)),0)) +    
  sum(isnull(cast(i.vl_frete_item as decimal(25,2)),0)) +
  sum(isnull(cast(i.vl_seguro_item as decimal(25,2)),0)) +
  sum(isnull(cast(i.vl_desp_acess_item as decimal(25,2)),0))    as 'VlContabil',
  sum(isnull(cast(i.vl_base_icms_item as decimal(25,2)),0))	as 'BCICMS',
  sum(isnull(cast(i.vl_base_ipi_item as decimal(25,2)),0))      as 'BCIPI',
  cast(i.pc_icms as decimal(25,2))				as 'AliqICMS',
  cast(i.pc_ipi as decimal(25,2))				as 'AliqIPI',
  sum(cast(i.vl_ipi as decimal(25,2))) 				as 'IPI',
  sum(cast(i.vl_icms_item as decimal(25,2)))                	as 'ICMS',
  /* ELIAS 20/06/2003 */
  case when sum(isnull(cast(i.vl_ipi_corpo_nota_saida as decimal(25,2)),0)) = 0 then
    sum(isnull(cast(i.vl_ipi_obs_item as decimal(25,2)),0))
  else
    sum(isnull(cast(i.vl_ipi_corpo_nota_saida as decimal(25,2)),0)) 
  end				     				as 'ObsIPI',
  sum(isnull(cast(i.vl_icms_obs_item as decimal(25,2)),0))	as 'ObsICMS',
  sum(cast(i.vl_frete_item as decimal(25,2))) 			as 'Frete',
  sum(cast(i.vl_seguro_item as decimal(25,2))) 			as 'Seguro',
  sum(cast(i.vl_desp_acess_item as decimal(25,2))) 		as 'DespAcess',
  i.pc_icms_desc_item						as 'DescICMS',
  i.pc_reducao_icms						as 'RedICMS',
  case when (n.cd_status_nota = 7) then 'S' else 'N' end 	as 'Cancelada',
  isnull(o.ic_servico_operacao,'N') 				as 'Servico',
  /* ELIAS 05/06/2003 - Trocado flag antes usado da Estado Parâmetro
     p/ flag gravado na própria NF - ZF */
  isnull(n.ic_zona_franca,'N') 					as 'ZonaFranca',
  isnull(ep.ic_resumo_saida,'S') 				as 'Resumo',
  /* ELIAS 05/06/2003 - Flag de Devolução */
  isnull(o.ic_devmp_operacao_fiscal,'N') 			as 'Devolucao',
  o.nm_obs_livro_operacao					as 'MsgObs',
  /* ELIAS 20/06/2003 - Outras */
  sum(isnull(cast(i.vl_icms_outros_item as decimal(25,2)),0)) 	as 'OutrosICMS',
  sum(isnull(cast(i.vl_ipi_outros_item as decimal(25,2)),0)) 	as 'OutrosIPI',
  /* ELIAS 24/06/2003 - MP66 */
  isnull(i.ic_mp66_item_nota_saida,'N')				as 'MP66',
  /* ELIAS 18/08/2003 - Campos de Serviço */
  sum(isnull(cast(i.vl_servico as decimal(25,2)),0))		as 'VlServico',
  i.pc_iss_servico						as 'AliqISS',
  sum(isnull(cast(i.vl_iss_servico as decimal(25,2)),0))	as 'ISS',  
  i.cd_servico							as 'CodServico',
  /* ELIAS 17/01/2004 */
  n.cd_serie_nota						as 'CodSerie'
into
  #NF
from
  Nota_Saida n
inner join
  Nota_Saida_Item i
on
  n.cd_nota_saida = i.cd_nota_saida
/* ELIAS 26/06/2003 */
inner join
  #NF_Reprocessada nsr
on
  nsr.cd_nota_saida = n.cd_nota_saida
left outer join
  Operacao_Fiscal o
on
  o.cd_operacao_fiscal = isnull(i.cd_operacao_fiscal,n.cd_operacao_fiscal)
/* ELIAS 18/11/2003 - FILTRANDO APENAS SAÍDA */
left outer join
  Grupo_Operacao_Fiscal gop
on
  gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
left outer join
  Estado e
on
  /* ELIAS 25/06/2003 */
  e.sg_estado = n.sg_estado_nota_saida and
  e.cd_pais = n.cd_pais  
left outer join
  Estado_Parametro ep
on
  ep.cd_estado = e.cd_estado and
  ep.cd_pais = e.cd_pais
where
  /* ELIAS 18/11/2003 - FILTRANDO APENAS SAÍDA */
  /* Alexandre 05/02/2004 - TIRAR O FILTRO gop.cd_tipo_operacao_fiscal PARA TRAZER TODAS AS NOTAS DE ENTRADA QUE FOI UTILIZADA COMO SAIDA */
--  gop.cd_tipo_operacao_fiscal = 2  and -- SAÍDA
  /* ELIAS 02/07/2003 - Não deve existir filtro para
     a geração de registros no livro em relação ao
     tipo de operação para a correta manutenção do
     livro */
  --isnull(g.cd_tipo_operacao_fiscal,2) = 2 and
  n.dt_nota_saida between @dt_inicial and @dt_final
group by
  n.cd_nota_saida,
  n.cd_num_formulario_nota,
  i.cd_item_nota_saida,
  n.dt_nota_saida,
  o.cd_mascara_operacao,
  o.cd_operacao_fiscal,
  o.ic_comercial_operacao,
  n.sg_estado_nota_saida,
  n.cd_destinacao_produto,
  i.cd_tributacao,
  o.ic_contribicms_op_fiscal,
  o.cd_tributacao,
  i.pc_icms,
  i.pc_ipi,
  i.pc_icms_desc_item,
  i.pc_reducao_icms,
  n.cd_status_nota,
  o.ic_servico_operacao,
  n.ic_zona_franca,
  ep.ic_resumo_saida,
  o.ic_devmp_operacao_fiscal,
  o.nm_obs_livro_operacao,
  i.ic_mp66_item_nota_saida,
  i.pc_iss_servico,
  i.cd_servico,
  /* ELIAS 17/01/2004 */
  n.cd_serie_nota
order by
  n.cd_nota_saida,
  i.cd_item_nota_saida

select 
NotaSaida,Formulario,ItemNota,ItemLivro,Especie,Serie,Emissao,UF,Destinacao,CFOP,CodCFOP,
ClassContabil,Tributacao,ContrICMS,VlProduto,
case when isnull(RedICMS,0) <> 0 then
cast((VlContabil - ((((VlContabil * isnull(RedICMS,0))/100)*isnull(DescICMS,0))/100))as decimal(25,2)) 
else
VlContabil
end as VlContabil,
BCICMS,
BCIPI,AliqICMS,AliqIPI,IPI,ICMS,ObsIPI,ObsICMS,Frete,Seguro,DespAcess,DescICMS,RedICMS,Cancelada,
Servico,ZonaFranca,Resumo,Devolucao,MsgObs,OutrosICMS,OutrosIPI,MP66, VlServico,AliqISS,ISS,CodServico,CodSerie    
from #NF 
union 
select 
NotaSaida,Formulario,ItemNota,ItemLivro,Especie,Serie,Emissao,UF,Destinacao,CFOP,CodCFOP,
ClassContabil,Tributacao,ContrICMS,VlProduto,
VlContabil,
BCICMS,
BCIPI,AliqICMS,AliqIPI,IPI,ICMS,ObsIPI,ObsICMS,Frete,Seguro,DespAcess,DescICMS,RedICMS,Cancelada,
Servico,ZonaFranca,Resumo,Devolucao,MsgObs,OutrosICMS,OutrosIPI,MP66, VlServico,AliqISS,ISS,CodServico,CodSerie 
from #NF_Sem_Item order by NotaSaida

drop table #NF_Reprocessada
drop table #NF
drop table #NF_Sem_Item

