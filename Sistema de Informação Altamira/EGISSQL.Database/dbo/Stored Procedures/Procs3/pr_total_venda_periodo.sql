
create procedure pr_total_venda_periodo

@dt_inicial datetime,
@dt_final   datetime
as

select
  sum(vl_total_pedido_venda) as TotalVenda
from
  Pedido_Venda
where
  dt_pedido_venda between @dt_inicial and @dt_final

