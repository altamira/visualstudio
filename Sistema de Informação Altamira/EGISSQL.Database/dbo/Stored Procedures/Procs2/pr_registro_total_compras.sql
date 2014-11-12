
create procedure pr_registro_total_compras
@dt_inicial datetime,
@dt_final   datetime
as

declare @vl_total_compras float

set @vl_total_compras = 0

--select * from pedido_compra

select  
  @vl_total_compras = sum( vl_total_pedido_compra  )
from 
  vw_compra_bi
where
  dt_pedido_compra between @dt_inicial and @dt_final

--Resultado

select 
  @vl_total_compras as 'TotalCompras'

