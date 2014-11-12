
create procedure pr_produtividade_vendas_direta
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_vendedor_venda int
declare @vl_total_venda    float


--Número de Vendedors que Efeturam Vendas
set @qt_vendedor_venda = 0


--Total de Vendas
set @vl_total_venda = 0


--select * from vw_venda_bi

--Total de Vendedores que Efeturam as Vendas

select  
  @qt_vendedor_venda = count('x') 
from 
  vw_venda_bi vw, cliente c
where 
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_cliente = c.cd_cliente and
  isnull(c.ic_distribuidor_cliente,'N') = 'N'
group by
  vw.cd_vendedor

--Total de Vendas
select  
  @vl_total_venda = sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido )
from 
  vw_venda_bi vw, cliente c
where 
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_cliente = c.cd_cliente and
  isnull(c.ic_distribuidor_cliente,'N') = 'N'

--Resultado

select 
  @qt_vendedor_venda                 as 'Vendedor',
  @vl_total_venda                    as 'Total',
  @vl_total_venda/@qt_vendedor_venda as 'VendaDireta'

