
create procedure pr_quantidade_linha_pedido_venda_vendedor
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_vendedor_venda        int
declare @qt_linha_pedido_vendedor int


--Número de Vendedors que Efeturam Vendas
set @qt_vendedor_venda = 0

--select * from vw_venda_bi
--  select count( cd_pedido_venda) from vw_venda_bi where 
--  dt_pedido_venda between '01/01/2004' and '01/31/2004' --@dt_inicial and @dt_final
--  --group by cd_pedido_venda

--Total de Vendedores que Efeturam as Vendas

select  
  @qt_vendedor_venda = count('x') 
from 
  vw_venda_bi
where 
  dt_pedido_venda between @dt_inicial and @dt_final
group by
  cd_vendedor

--Total de Vendas

select  
  @qt_linha_pedido_vendedor = count(cd_item_pedido_venda)
from 
  vw_venda_bi
where 
  dt_pedido_venda between @dt_inicial and @dt_final

--Resultado

select 
  @qt_vendedor_venda                           as 'QtdVendedor',
  @qt_linha_pedido_vendedor                    as 'QtdLinha',
  @qt_linha_pedido_vendedor/@qt_vendedor_venda as 'LinhaVendedor'

