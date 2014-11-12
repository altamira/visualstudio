
create procedure pr_total_vendas_direta_periodo
@dt_inicial datetime,
@dt_final   datetime
as

declare @vl_total_venda    float

--Total de Vendas

set @vl_total_venda = 0

select  
  @vl_total_venda = sum( qt_item_pedido_venda * vl_unitario_item_pedido )
from 
  vw_venda_bi vw, 
  cliente c
where 
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_cliente = c.cd_cliente and
  isnull(c.ic_distribuidor_cliente,'N') = 'N'

--Resultado

select 
  @vl_total_venda                    as 'TotalVendaDiretaPeriodo'

