
create procedure pr_total_vendas_categoria_cliente
@dt_inicial datetime,
@dt_final   datetime
as

select  
  max(cc.sg_categoria_cliente)                                  as 'CategoriaCliente',
  sum ( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido )  as 'TotalVendas'
from 
  vw_venda_bi vw, 
  Cliente c, 
  Categoria_Cliente cc
where 
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_cliente = c.cd_cliente and
  c.cd_categoria_cliente = cc.cd_categoria_cliente
group by
  cc.cd_categoria_cliente

