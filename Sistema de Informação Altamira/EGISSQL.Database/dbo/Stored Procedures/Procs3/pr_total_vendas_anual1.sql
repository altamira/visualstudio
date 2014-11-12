--pr_total_vendas_anual1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Total de Vendas da Polimold Anual
--Data       : 05.07.2000 - Lucio (Trocada para Período)
--Atualizado : 
-----------------------------------------------------------------------------------
create procedure pr_total_vendas_anual1
@dt_inicial datetime,
@dt_final datetime
as
select sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido) as 'TotalVendas'
from
  pedido_venda a, pedido_venda_item b
Where
  (a.dt_pedido_venda between @dt_inicial and @dt_final) and
   a.vl_total_pedido_venda > 0 and
   a.dt_cancelamento_pedido is null and
   a.cd_pedido_venda = b.cd_pedido_venda and     
  (b.qt_item_pedido_venda*b.vl_unitario_item_pedido) > 0 and
   b.dt_cancelamento_item is null 
