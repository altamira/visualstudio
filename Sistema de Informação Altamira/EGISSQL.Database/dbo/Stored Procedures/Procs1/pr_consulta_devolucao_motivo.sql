
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_devolucao_motivo
-------------------------------------------------------------------------------
--pr_consulta_devolucao_motivo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Devolução de Notas Fiscais por Motivo
--Data             : 29.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_devolucao_motivo
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from motivo_devolucao_nota
--select * from nota_saida
--select * from nota_saida_item

select
  md.cd_motivo_dev_nota,
  max(md.nm_motivo_dev_nota)                                  as nm_motivo_dev_nota,
  sum(nsi.vl_unitario_item_nota * nsi.qt_devolucao_item_nota) as vl_total,
  count(ns.cd_nota_saida)                                     as qtd_nota
into
  #MotivoDevolucao  
from
  nota_saida                 ns            with (nolock) 
  inner join nota_saida_item nsi           with (nolock) on nsi.cd_nota_saida     = ns.cd_nota_saida
  left outer join motivo_devolucao_nota md with (nolock) on md.cd_motivo_dev_nota = nsi.cd_motivo_dev_nota

where
  nsi.dt_restricao_item_nota between @dt_inicial and @dt_final

group by
  md.cd_motivo_dev_nota

declare @vl_total float

set @vl_total = 0

select 
  @vl_total = sum( vl_total )
from
  #MotivoDevolucao

select
  *,
  Perc = (vl_total/@vl_total*100)
from
  #MotivoDevolucao
order by
  vl_total desc
  

