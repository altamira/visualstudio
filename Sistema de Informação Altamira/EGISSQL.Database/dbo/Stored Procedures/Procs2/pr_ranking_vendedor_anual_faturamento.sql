
-------------------------------------------------------------------------------
--pr_ranking_vendedor_anual_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Ranking de Vendas por Vendedor
--Data             : 02.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ranking_vendedor_anual_faturamento
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from vw_faturamento_bi

Select 
      vw.nm_vendedor_externo                as 'Vendedor',

      --Total do Ano
     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlJaneiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlFevereiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlMarco',
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlAbril',
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlMaio',
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlJunho',
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlJulho',
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlAgosto',
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlSetembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlOutubro',
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlNovembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.qt_item_nota_saida*vw.vl_unitario_item_nota end,0)) as 'vlDezembro',

      --Média

     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.qt_item_nota_saida * vw.vl_unitario_item_nota end,0))) / 12 as 'Media'

into
  #FaturamentoReal
from
  vw_faturamento_bi vw
where
  vw.dt_nota_saida between @dt_inicial and @dt_final
Group By 
   vw.nm_vendedor_externo

declare  @vl_total float

set @vl_total = 0

select
  @vl_total = @vl_total + isnull(total_ano,0)
from
  #FaturamentoReal
  

--select @vl_total

select 
  IDENTITY(int, 1,1)                   AS 'Posicao',
  *,
  Perc = cast(( total_ano / @vl_total ) * 100 as float )
into
  #Faturamento
from 
  #FaturamentoReal
order by
  total_ano desc
  
select * from #Faturamento

