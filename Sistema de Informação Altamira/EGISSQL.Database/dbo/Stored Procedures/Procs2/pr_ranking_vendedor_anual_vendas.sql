
-------------------------------------------------------------------------------
--pr_ranking_vendedor_anual_vendas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Ranking de Vendas por Vendedor
--Data             : 02.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ranking_vendedor_anual_vendas
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from vw_venda_bi

Select 
      vw.nm_vendedor_externo                as 'Vendedor',

      --Total do Ano
     (sum(isnull(case when month(vw.dt_pedido_venda) = 1  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 2  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 3  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 4  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 5  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 6  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 7  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 8  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 9  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 10 then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 11 then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 12 then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_pedido_venda) = 1  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlJaneiro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 2  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlFevereiro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 3  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlMarco',
      sum(isnull(case when month(vw.dt_pedido_venda) = 4  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlAbril',
      sum(isnull(case when month(vw.dt_pedido_venda) = 5  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlMaio',
      sum(isnull(case when month(vw.dt_pedido_venda) = 6  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlJunho',
      sum(isnull(case when month(vw.dt_pedido_venda) = 7  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlJulho',
      sum(isnull(case when month(vw.dt_pedido_venda) = 8  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlAgosto',
      sum(isnull(case when month(vw.dt_pedido_venda) = 9  then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlSetembro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 10 then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlOutubro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 11 then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlNovembro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 12 then vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido end,0)) as 'vlDezembro',

      --Média

     (sum(isnull(case when month(vw.dt_pedido_venda) = 1  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 2  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 3  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 4  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 5  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 6  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 7  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 8  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 9  then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 10 then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 11 then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 12 then vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido end,0))) / 12 as 'Media'

into
  #VendaReal
from
  vw_venda_bi vw
where
  vw.dt_pedido_venda between @dt_inicial and @dt_final
Group By 
   vw.nm_vendedor_externo

declare  @vl_total float

set @vl_total = 0

select
  @vl_total = @vl_total + isnull(total_ano,0)
from
  #VendaReal
  

--select @vl_total

select 
  IDENTITY(int, 1,1)                   AS 'Posicao',
  *,
  Perc = cast(( total_ano / @vl_total ) * 100 as float )
into
  #Venda
from 
  #VendaReal
order by
  total_ano desc
  
select * from #Venda

