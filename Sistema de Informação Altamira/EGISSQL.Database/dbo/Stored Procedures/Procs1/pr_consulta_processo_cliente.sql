
CREATE PROCEDURE pr_consulta_processo_cliente

--pr_consulta_processo_cliente
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Processos por Cliente.
--Data          : 23/08/2002
--Atualizado    : 29/04/2004 - Trazer registros mesmo não havendo cliente - DANIEL DUELA
---------------------------------------------------

@nm_fantasia_cliente varchar(20),
@dt_inicial    datetime,
@dt_final      datetime

AS

select
  pp.cd_processo, 
  pp.dt_processo, 
  pp.ic_mapa_processo, 
  pp.cd_pedido_venda, 
  pp.cd_item_pedido_venda, 
  isnull(c.nm_fantasia_cliente,'(Sem Cliente)') as nm_fantasia_cliente, 
  pvi.qt_item_pedido_venda, 
  pvi.nm_fantasia_produto, 
  pvi.dt_entrega_vendas_pedido 
from
Processo_Producao pp 
left outer join Pedido_Venda pv on
  pp.cd_pedido_venda = pv.cd_pedido_venda 
left outer join Cliente c on
  pv.cd_cliente = c.cd_cliente 
left outer join Pedido_Venda_Item pvi on
  pv.cd_pedido_venda = pvi.cd_pedido_venda
where     
  ((isnull(@nm_fantasia_cliente,'') = '' and pp.dt_processo between @dt_inicial and @dt_final) or
   c.nm_fantasia_cliente like @nm_fantasia_cliente + '%') and
  pv.dt_cancelamento_pedido is null and pvi.dt_cancelamento_item is null
order by  
  c.nm_fantasia_cliente desc,
  pp.cd_processo

