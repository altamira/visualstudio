
CREATE PROCEDURE pr_lista_preco_caixa
@dt_inicial datetime,
@dt_final   datetime
AS


select
  gp.nm_grupo_produto   as Grupo,
  p.cd_mascara_produto  as Codigo,
  p.nm_fantasia_produto as Fantasia,
  p.nm_produto          as Descricao,
  um.sg_unidade_medida  as Unidade,
  p.vl_produto          as PrecoVenda

from
  Produto p
  left outer join Grupo_Produto gp  on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
where
  isnull(p.cd_status_produto,1) = 1              and 
  isnull(p.ic_lista_preco_caixa_produto,'S')='S' and
  isnull(p.vl_produto,0)>0           
order by
  gp.nm_grupo_produto,
  p.nm_fantasia_produto

