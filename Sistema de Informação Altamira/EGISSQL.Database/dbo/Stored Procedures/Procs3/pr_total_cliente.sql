

/****** Object:  Stored Procedure dbo.pr_total_cliente    Script Date: 13/12/2002 15:08:43 ******/

create procedure pr_total_cliente
@cd_cliente int,
-- @nm_fantasia_cliente varchar(15),
@dt_inicial datetime,
@dt_final   datetime
as
select c.nm_fantasia_cliente as 'Cliente', CAST(sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido) as int) 'totalvenda'
into #TotalClienteAux
from
--   CADPED a, CADIPED b
    Pedido_Venda a, Pedido_Venda_Item b, Cliente c
Where
    a.cd_cliente = @cd_cliente            and
   (a.dt_pedido_venda between @dt_inicial and @dt_final ) and
   (a.dt_cancelamento_pedido is null )                    and 
    isnull(a.ic_consignacao_pedido,'N') = 'N'             and 
    a.cd_pedido_venda = b.cd_pedido_venda                 and
    a.cd_cliente = c.cd_cliente                           and
  ( b.dt_cancelamento_item is null )
Group by c.nm_fantasia_cliente
order by 2 desc
--Mostra tabela ao usuário
select totalvenda from #TotalClienteAux



