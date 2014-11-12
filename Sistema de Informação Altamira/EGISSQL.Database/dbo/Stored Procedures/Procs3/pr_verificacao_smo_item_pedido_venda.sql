
create procedure pr_verificacao_smo_item_pedido_venda
@cd_pedido_venda int

as

Select top 1
  'N' as 'SMO', --Define que o pedido de venda não poderá ser transformado em SMO
  gp.nm_fantasia_grupo_produto
from
  pedido_venda_item pvi with (nolock)
  inner join grupo_produto gp with (nolock)
    on pvi.cd_grupo_produto = gp.cd_grupo_produto
  inner join grupo_produto_custo gpc with (nolock)
    on pvi.cd_grupo_produto = gpc.cd_grupo_produto
where
  pvi.cd_pedido_venda   = @cd_pedido_venda and
  isnull(gpc.ic_smo_grupo_produto,'N') = 'N'
