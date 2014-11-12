
create procedure pr_verificacao_smo_item_consulta
@cd_consulta int

as

select
  isnull(gpc.ic_smo_grupo_produto,'N') as 'SMO'
from
   consulta_itens       ic, 
   grupo_produto        gp,
   grupo_produto_custo gpc
where
  @cd_consulta        = ic.cd_consulta      and
  ic.cd_grupo_produto = gp.cd_grupo_produto and
  gp.cd_grupo_produto = gpc.cd_grupo_produto 
group by
  isnull(gpc.ic_smo_grupo_produto,'N') 
