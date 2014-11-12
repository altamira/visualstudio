
create procedure pr_registro_total_compras_aplicacao
@dt_inicial datetime,
@dt_final   datetime
as


--select * from pedido_compra
--select * from aplicacao_produto
select  
  max(ap.nm_aplicacao_produto)   as 'Aplicacao',
  sum(vw.vl_total_pedido_compra) as 'TotalCompra'

from 
  vw_compra_bi vw,
  aplicacao_produto ap
where
  vw.dt_pedido_compra between @dt_inicial and @dt_final and
  vw.cd_aplicacao_produto = ap.cd_aplicacao_produto

group by 
  ap.cd_aplicacao_produto 

