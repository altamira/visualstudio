

/****** Object:  Stored Procedure dbo.pr_venda_ano    Script Date: 13/12/2002 15:08:43 ******/

create procedure pr_venda_ano
as

select 
-- a.nm_fantasia_cliente,
 year(b.dt_pedido_venda)     as 'Ano',
 sum(b.vl_total_pedido_venda)as 'Total'
 
from 
  cliente a,pedido_venda b
where
  a.cd_cliente = b.cd_cliente and
  b.vl_total_pedido_venda > 0

group by
--  a.nm_fantasia_cliente,
  year(b.dt_pedido_venda)
order by 1,2 desc  



