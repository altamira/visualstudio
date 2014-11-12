
CREATE PROCEDURE pr_produto_sem_preco_reposicao
@dt_inicial datetime,
@dt_final   datetime
AS


select
  gp.nm_grupo_produto   as Grupo,
  p.nm_fantasia_produto as Fantasia,
  p.nm_produto          as Descricao

from
  Produto p
  left outer join produto_custo pc on pc.cd_produto       = p.cd_produto
  left outer join Grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
where
  isnull(p.cd_status_produto,1) = 1 and 
  isnull(pc.vl_custo_produto,0) = 0
order by
  gp.nm_grupo_produto,
  p.nm_fantasia_produto

