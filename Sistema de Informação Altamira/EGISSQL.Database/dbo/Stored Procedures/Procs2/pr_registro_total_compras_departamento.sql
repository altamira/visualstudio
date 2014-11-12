
create procedure pr_registro_total_compras_departamento
@dt_inicial datetime,
@dt_final   datetime
as


--select * from pedido_compra

select  
  max(d.nm_departamento)         as 'Departamento',
  sum(vw.vl_total_pedido_compra) as 'TotalCompra'

from 
  vw_compra_bi vw,
  departamento d
where
  vw.dt_pedido_compra between @dt_inicial and @dt_final and
  vw.cd_departamento = d.cd_departamento

group by 
  d.cd_departamento

