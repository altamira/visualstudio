
-------------------------------------------------------------------------------
--pr_pedido_venda_sem_categoria_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Notas Fiscais sem Categoria de Produto
--
--Data             : 28/10/2005
--Atualizado       : 28/10/2005 
--
--
-- 02.02.2008 - Acerto do Item do Pedido de Venda Cancelado - Carlos Fernandes
--
--------------------------------------------------------------------------------------------------
create procedure pr_pedido_venda_sem_categoria_produto
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from pedido_venda_item

select
  v.nm_fantasia_vendedor      as Vendedor,
  pv.dt_pedido_venda          as Emissao,
  pv.cd_pedido_venda          as Pedido,
  pvi.cd_item_pedido_venda    as ItemPed,
  sp.nm_status_pedido         as Status,
  pvi.qt_item_pedido_venda    as Qtd,
  pvi.nm_fantasia_produto     as Produto,
  pvi.nm_produto_pedido       as Descricao,
  c.nm_fantasia_cliente       as Cliente
from
  Pedido_Venda pv with (nolock) 
  inner join pedido_venda_item pvi with (nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
  left outer join status_pedido sp with (nolock) on sp.cd_status_pedido = pv.cd_status_pedido
  left outer join vendedor      v  with (nolock) on v.cd_vendedor       = pv.cd_vendedor
  left outer join cliente       c  with (nolock) on c.cd_cliente        = pv.cd_cliente
where
  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  isnull(pvi.cd_categoria_produto,0) = 0 and
  pvi.dt_cancelamento_item is null


