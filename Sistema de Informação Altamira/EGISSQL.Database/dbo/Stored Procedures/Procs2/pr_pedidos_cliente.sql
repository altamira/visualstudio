

/****** Object:  Stored Procedure dbo.pr_pedidos_cliente    Script Date: 13/12/2002 15:08:38 ******/

CREATE PROCEDURE pr_pedidos_cliente

@cd_cliente int,
@dt_inicial datetime,
@dt_final   datetime

AS

select a.cd_pedido_venda, 
       a.dt_pedido_venda, b.cd_item_pedido_venda, 
       b.qt_item_pedido_venda, 
       b.ds_produto_pedido_venda,
       b.qt_item_pedido_venda*b.vl_unitario_item_pedido as 'total',
       b.dt_entrega_fabrica_pedido,b.qt_saldo_pedido_venda,
       a.cd_cliente
into #Clientecompra
from
   pedido_venda a, pedido_venda_item b
WHERE

    a.cd_cliente = @cd_cliente            and
  ( a.dt_pedido_venda between @dt_inicial and @dt_final ) and 
  ( a.dt_cancelamento_pedido is null )                           and
    isnull(a.ic_consignacao_pedido,'N') = 'N'                  and
    a.cd_pedido_venda = b.cd_pedido_venda                       and
  ( b.dt_cancelamento_item is null ) 

order by a.dt_pedido_venda desc

select * from #ClienteCompra order by 2 desc ,1,3



