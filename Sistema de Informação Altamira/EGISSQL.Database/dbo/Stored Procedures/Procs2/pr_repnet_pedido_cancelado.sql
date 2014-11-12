



CREATE  PROCEDURE pr_repnet_pedido_cancelado
  @ic_tipo_usuario as varchar(10),
  @cd_tipo_usuario as int,
  @nm_fantasia_cliente varchar(30),
  @dt_inicial as Datetime,
  @dt_final as Datetime
AS


if @ic_tipo_usuario='Vendedor'
begin
select
   isnull(c.cd_pedido_venda,0) as 'Pedido',
   c.dt_pedido_venda as 'Datapedido',
   isnull(i.cd_item_pedido_venda,0) as 'Item',
   isnull(i.qt_item_pedido_venda,0) as 'Qtd',
   isnull(i.vl_unitario_item_pedido,0) as 'Preco',
   isnull(i.nm_fantasia_produto,'') as 'Descricao',
   isnull(DATEDIFF(day, c.dt_pedido_venda, getdate()),0) as 'Dias',
   isnull(cli.nm_fantasia_cliente,'') as 'Cliente'
from
   Pedido_venda c 
   left outer join pedido_venda_item i
   on c.cd_pedido_venda = i.cd_pedido_venda
   left outer join Cliente cli
   on c.cd_cliente = cli.cd_cliente
   where c.cd_vendedor=@cd_tipo_usuario and 
   cli.nm_fantasia_cliente like @nm_fantasia_cliente+'%' and
   c.dt_pedido_venda between @dt_inicial and @dt_final and
   i.dt_cancelamento_item is not null
   order by c.dt_pedido_venda,c.cd_pedido_venda, i.cd_item_pedido_venda
end

if @ic_tipo_usuario='Cliente'
begin
select
   isnull(c.cd_pedido_venda,0) as 'Pedido',
   c.dt_pedido_venda as 'Datapedido',
   isnull(i.cd_item_pedido_venda,0) as 'Item',
   isnull(i.qt_item_pedido_venda,0) as 'Qtd',
   isnull(i.vl_unitario_item_pedido,0) as 'Preco',
   isnull(i.nm_fantasia_produto,'') as 'Descricao',
   isnull(DATEDIFF(day, c.dt_pedido_venda, getdate()),0) as 'Dias',
   isnull(cli.nm_fantasia_cliente,'') as 'Cliente'
from
   Pedido_venda c 
   left outer join pedido_venda_item i
   on c.cd_pedido_venda = i.cd_pedido_venda
   left outer join Cliente cli
   on c.cd_cliente = cli.cd_cliente
   where c.cd_cliente=@cd_tipo_usuario and 
   cli.nm_fantasia_cliente like @nm_fantasia_cliente+'%' and
   c.dt_pedido_venda between @dt_inicial and @dt_final and
   i.dt_cancelamento_item is not null
   order by c.dt_pedido_venda,c.cd_pedido_venda, i.cd_item_pedido_venda
end

if @ic_tipo_usuario='Supervisor'
begin
select
   isnull(c.cd_pedido_venda,0) as 'Pedido',
   c.dt_pedido_venda as 'Datapedido',
   isnull(i.cd_item_pedido_venda,0) as 'Item',
   isnull(i.qt_item_pedido_venda,0) as 'Qtd',
   isnull(i.vl_unitario_item_pedido,0) as 'Preco',
   isnull(i.nm_fantasia_produto,'') as 'Descricao',
   isnull(DATEDIFF(day, c.dt_pedido_venda, getdate()),0) as 'Dias',
   isnull(cli.nm_fantasia_cliente,'') as 'Cliente'
from
   Pedido_venda c 
   left outer join pedido_venda_item i
   on c.cd_pedido_venda = i.cd_pedido_venda
   left outer join Cliente cli
   on c.cd_cliente = cli.cd_cliente
   where cli.nm_fantasia_cliente like @nm_fantasia_cliente+'%' and
   c.dt_pedido_venda between @dt_inicial and @dt_final and
   i.dt_cancelamento_item is not null
   order by c.dt_pedido_venda,c.cd_pedido_venda, i.cd_item_pedido_venda
end







