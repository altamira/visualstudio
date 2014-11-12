
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_pedido_venda_bonificacao
-------------------------------------------------------------------------------
--pr_consulta_pedido_venda_bonificacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Pedidos de Venda de Bonificação
--Data             : 19.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_pedido_venda_bonificacao
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from pedido_venda
--select * from pedido_venda_item


select
  pv.cd_pedido_venda,
  pv.dt_pedido_venda                                               as Data_Emissao,
  c.nm_fantasia_cliente,
  v.nm_fantasia_vendedor,
  pv.vl_total_pedido_venda,
  pvi.cd_item_pedido_venda,
  pvi.qt_item_pedido_venda,
  pvi.qt_saldo_pedido_venda,
  p.cd_mascara_produto,
  pvi.nm_fantasia_produto,
  pvi.nm_produto_pedido,
  pvi.qt_saldo_pedido_venda * isnull(pvi.vl_unitario_item_pedido,0) as Total_Item,
  pvi.vl_unitario_item_pedido,
  pvi.dt_entrega_vendas_pedido
  
from
  Pedido_Venda pv            with (nolock)
  left outer join cliente c  with (nolock) on c.cd_cliente  = pv.cd_cliente
  left outer join vendedor v with (nolock) on v.cd_vendedor = pv.cd_vendedor
  left outer join pedido_venda_item pvi    on pvi.cd_pedido_venda = pv.cd_pedido_venda
  left outer join produto  p with (nolock) on p.cd_produto   = pvi.cd_produto

where
  pv.dt_pedido_venda between @dt_inicial and @dt_final
  and
  isnull(pv.ic_bonificacao_pedido_venda,'N') = 'S' and
  pvi.dt_cancelamento_item is null
order by
  pv.dt_pedido_venda desc


