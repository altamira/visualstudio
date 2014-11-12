
CREATE PROCEDURE pr_pedidos_aguardando
@dt_inicial datetime,
@dt_final datetime
 

AS

select 
  t.sg_tipo_pedido,
  p.cd_pedido_venda,
  p.dt_pedido_venda,
  i.cd_item_pedido_venda,
  (Select nm_fantasia_produto from Produto 
   where cd_produto = i.cd_produto and cd_grupo_produto = i.cd_grupo_produto) as 'nm_produto',
  c.nm_fantasia_cliente,
  i.dt_entrega_vendas_pedido,
  i.dt_entrega_fabrica_pedido,  
  tr.sg_tipo_restricao,
  tr.nm_tipo_restricao_pedido as nm_tipo_resticao,
  p.cd_vendedor_pedido,
  (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_pedido) as 'nm_vendedor_externo',
  p.cd_vendedor_interno,
  (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_interno) as 'nm_vendedor_interno'
from
  Pedido_Venda p Left Outer Join
  Pedido_Venda_Item i on p.cd_pedido_venda = i.cd_pedido_venda left outer join  
  Tipo_Pedido t on p.cd_tipo_pedido = t.cd_tipo_pedido Left outer join
  Cliente c on p.cd_cliente = c.cd_cliente Left outer join
  Tipo_Restricao_Pedido tr on p.cd_tipo_restricao_pedido = tr.cd_tipo_restricao_pedido
where
  ISNULL(p.cd_tipo_restricao_pedido,0) > 0 and
  p.dt_pedido_venda between @dt_inicial and @dt_final
order by p.cd_pedido_venda

