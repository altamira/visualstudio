
--select * from grupo_produto
--select * from produto_importacao

CREATE PROCEDURE pr_consulta_sem_custo_produto_importacao
@dt_inicial datetime,
@dt_final   datetime
AS

select
  gp.nm_grupo_produto   as Grupo,
  p.cd_produto 		as Codigo,
  p.nm_fantasia_produto as Fantasia,
  p.nm_produto          as Descricao,
  un.nm_unidade		as Unidade

from
  Produto p
  left outer join produto_importacao pc on pc.cd_produto       = p.cd_produto
  left outer join Grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join Unidade un on un.cd_unidade = p.cd_unidade_medida

where
  isnull(p.cd_status_produto,1) = 1 and 
  isnull(pc.vl_produto_importacao,0) = 0 

order by
  gp.nm_grupo_produto,
  p.nm_fantasia_produto

