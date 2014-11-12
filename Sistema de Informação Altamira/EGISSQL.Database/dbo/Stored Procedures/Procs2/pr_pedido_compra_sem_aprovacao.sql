
create procedure pr_pedido_compra_sem_aprovacao
@dt_inicial datetime,
@dt_final   datetime
as


  select
    p.cd_pedido_compra       as 'Pedido',
    p.dt_pedido_compra       as 'Emissao',
    f.nm_fantasia_fornecedor as 'Fornecedor',
    p.vl_total_pedido_compra as 'TotalPedido',
    p.dt_nec_pedido_compra   as 'Necessidade',
    d.nm_destinacao_produto  as 'Destinacao',
  ( select min(dt_entrega_item_ped_compr) 
    from Pedido_Compra_Item x 
    where x.cd_pedido_compra = p.cd_pedido_compra ) as 'DataEntrega'

  from
    Pedido_Compra p
  left outer join
    Fornecedor f
  on
    p.cd_fornecedor = f.cd_fornecedor
  left outer join 
    Destinacao_Produto d
  on
    p.cd_destinacao_produto = d.cd_destinacao_produto
  where
    p.dt_pedido_compra between @dt_inicial and @dt_final and
    p.dt_cancel_ped_compra is null and
    IsNull(p.ic_aprov_pedido_compra,'N') = 'N'
  order by
    p.dt_pedido_compra 
    
