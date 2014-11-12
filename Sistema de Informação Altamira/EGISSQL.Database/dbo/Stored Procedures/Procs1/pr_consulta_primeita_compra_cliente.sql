
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_primeita_compra_cliente
-------------------------------------------------------------------------------
--pr_consulta_primeita_compra_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Primeira Compra do Cliente 
--Data             : 07.10.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_primeita_compra_cliente
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from vw_venda_bi

select
  vw.cd_cliente,
  vw.nm_fantasia_cliente,
  max(vw.nm_vendedor_externo) as nm_vendedor_externo,
  max(vw.nm_vendedor_interno) as nm_vendedor_interno,
  min(dt_pedido_venda)        as dt_pedido_venda,
--  min(vl_total_pedido_venda)  as vl_total_pedido_venda,
  sum(qt_item_pedido_venda)   as qt_volume_compra,
  sum(vl_total_pedido_venda ) as vl_volume_compra,
  max(dt_pedido_venda)        as dt_ultima_compra

into
  #AnaliseVenda

from
  vw_venda_bi vw with (nolock)
where
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.dt_cancelamento_pedido is null

group by
  vw.cd_cliente,
  vw.nm_fantasia_cliente

order by 
  vw.dt_pedido_venda desc

select
  vw.*,
  ( select top 1 isnull(cd_pedido_venda,0)
    from pedido_venda 
    where 
      dt_pedido_venda = vw.dt_pedido_venda and
      dt_cancelamento_pedido is null) as cd_pedido_venda,

  ( select top 1 isnull(vl_total_pedido_ipi,0)
    from pedido_venda 
    where 
      dt_pedido_venda = vw.dt_pedido_venda and
      dt_cancelamento_pedido is null) as vl_total_pedido_venda

from
  #AnaliseVenda vw
order by
  vw.dt_pedido_venda desc



