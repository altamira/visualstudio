
-------------------------------------------------------------------------------
--sp_helptext pr_cancelamento_pedido_venda_periodo
-------------------------------------------------------------------------------
--pr_cancelamento_pedido_venda_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cancelamento de Pedido de Venda em Aberto por Período
--                   
--Data             : 01.05.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_cancelamento_pedido_venda_periodo
@dt_base         datetime = null,
@dt_cancelamento datetime = null

as

--select * from tipo_pedido
--select * from status_pedido
--select * from pedido_venda_item
--select * from pedido_venda


declare @cd_status_pedido int

set @cd_status_pedido = 7  --Pedido de Venda Cancelado

select
  pv.cd_pedido_venda,
  pv.dt_pedido_venda
into
  #Pedido
from
  pedido_venda pv
  inner join pedido_venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
where
  isnull(pvi.qt_saldo_pedido_venda,0)>0 and
  pv.dt_pedido_venda <= @dt_base

update
  pedido_venda_item
set
  qt_saldo_pedido_venda   = 0,
  dt_cancelamento_item    = @dt_cancelamento,
  nm_mot_canc_item_pedido = 'Cancelamento Automático pelo Sistema'

from
  pedido_venda_item pvi
  inner join #Pedido pv on pv.cd_pedido_venda = pvi.cd_pedido_venda

update
  pedido_venda
set
  cd_status_pedido       = @cd_status_pedido,
  dt_cancelamento_pedido = @dt_cancelamento
from
  pedido_venda pv 
  inner join #Pedido p on p.cd_pedido_venda = pv.cd_pedido_venda

