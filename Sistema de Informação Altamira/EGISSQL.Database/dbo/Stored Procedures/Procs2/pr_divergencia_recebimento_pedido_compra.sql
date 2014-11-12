
create procedure pr_divergencia_recebimento_pedido_compra
@dt_inicial datetime,
@dt_final datetime

as


select 
  distinct 
  n.cd_nota_entrada,
  n.dt_receb_nota_entrada,
  n.dt_nota_entrada,
  d.nm_fantasia,
  c.cd_pedido_compra,
  c.cd_item_pedido_compra,
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
  p.nm_fantasia_produto,
  i.nm_produto_nota_entrada,
  u.sg_unidade_medida,
  case when isnull(u.ic_fator_conversao,'P') = 'K' then
    i.qt_item_nota_entrada * i.qt_pesliq_nota_entrada
  else
    i.qt_item_nota_entrada
  end as qt_item_nota_entrada,
  i.vl_item_nota_entrada,   
  case when isnull(u.ic_fator_conversao,'P') = 'K' then
    c.qt_item_pedido_compra * c.qt_item_pesliq_ped_compra
  else
    c.qt_item_pedido_compra
  end as qt_item_pedido_compra,
  c.vl_item_unitario_ped_comp,
  c.pc_ipi,
  i.pc_ipi_nota_entrada
from
  Nota_Entrada n
inner join
  Nota_Entrada_Item i
on
  i.cd_nota_entrada = n.cd_nota_entrada
inner join
  vw_Destinatario d
on
  d.cd_tipo_destinatario = n.cd_tipo_destinatario and
  d.cd_destinatario = n.cd_fornecedor
inner join
  Pedido_Compra_Item c
on
  c.cd_pedido_compra = i.cd_pedido_compra and
  c.cd_item_pedido_compra = i.cd_item_pedido_compra
left outer join
  Unidade_Medida u
on
  u.cd_unidade_medida = i.cd_unidade_medida
left outer join
  Produto p
on
  p.cd_produto = i.cd_produto
where
  n.dt_receb_nota_entrada between @dt_inicial and @dt_final and
  (i.qt_item_nota_entrada <> c.qt_item_pedido_compra or
   i.vl_item_nota_entrada <> c.vl_item_unitario_ped_comp or
   c.pc_ipi <> i.pc_ipi_nota_entrada)

order by
  d.nm_fantasia,
  n.cd_nota_entrada, 
  n.dt_receb_nota_entrada,  
  c.cd_pedido_compra,
  c.cd_item_pedido_compra


