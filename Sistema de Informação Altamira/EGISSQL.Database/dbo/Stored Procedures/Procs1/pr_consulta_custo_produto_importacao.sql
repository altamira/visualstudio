
--select * from grupo_produto
--select * from produto_importacao

CREATE PROCEDURE pr_consulta_custo_produto_importacao
@dt_inicial datetime,
@dt_final   datetime
AS

select
  gp.nm_grupo_produto   as Grupo,
  p.cd_produto 		as Codigo,
  p.nm_fantasia_produto as Fantasia,
  p.nm_produto          as Descricao,
  pa.nm_pais		as Pais,
  md.nm_moeda		as Moeda,
  pc.vl_produto_importacao as 'Valor Custo',
  pc.qt_lead_time_produto as Dias,
  pc.qt_transtime_produto as Transporte,
  pp.nm_pais as 'Pais Procedencia'

from
  Produto p
  left outer join produto_importacao pc on pc.cd_produto       = p.cd_produto
  left outer join Grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join Pais pa on pc.cd_pais = pa.cd_pais
  left outer join Moeda md on pc.cd_moeda = md.cd_moeda
  left outer join Pais pp on pc.cd_pais = pp.cd_pais
where
  isnull(p.cd_status_produto,1) = 1 /*and 
  isnull(pc.vl_produto_importacao,0) = 0 */
order by
  gp.nm_grupo_produto,
  p.nm_fantasia_produto

