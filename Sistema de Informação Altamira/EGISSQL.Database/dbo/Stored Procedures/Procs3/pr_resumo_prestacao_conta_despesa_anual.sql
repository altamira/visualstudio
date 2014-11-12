
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_prestacao_conta_despesa_anual
-------------------------------------------------------------------------------
--pr_resumo_prestacao_conta_despesa_anual
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Prestação de Conta por Centro de Custo
--Data             : 19.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_resumo_prestacao_conta_despesa_anual
@ic_tipo_consulta char(1)  = 'E', --Emissão / Competência
@dt_inicial       datetime = '',
@dt_final         datetime = ''

as

declare @vl_total_prestacao decimal(25,2)

set @vl_total_prestacao = 0.00

    select
      d.cd_tipo_despesa,
      max(d.nm_tipo_despesa)                     as nm_tipo_despesa,
      count(*)                                   as qt_prestacao,
      sum( isnull(r.vl_prestacao_corrigido,0) )  as vl_prestacao,
      sum( isnull(r.vl_pagamento_empresa,0))     as vl_pagamento_empresa,
      sum( isnull(r.vl_pagamento_funcionario,0)) as vl_pagamento_funcionario,
      sum( isnull(d.vl_total_despesa,0))         as vl_total_despesa,
      sum(isnull(case when month(r.dt_prestacao) = 1  then d.vl_total_despesa else 0 end,0)) as 'Janeiro',
      sum(isnull(case when month(r.dt_prestacao) = 2  then d.vl_total_despesa else 0 end,0)) as 'Fevereiro',
      sum(isnull(case when month(r.dt_prestacao) = 3  then d.vl_total_despesa else 0 end,0)) as 'Marco',
      sum(isnull(case when month(r.dt_prestacao) = 4  then d.vl_total_despesa else 0 end,0)) as 'Abril',
      sum(isnull(case when month(r.dt_prestacao) = 5  then d.vl_total_despesa else 0 end,0)) as 'Maio',
      sum(isnull(case when month(r.dt_prestacao) = 6  then d.vl_total_despesa else 0 end,0)) as 'Junho',
      sum(isnull(case when month(r.dt_prestacao) = 7  then d.vl_total_despesa else 0 end,0)) as 'Julho',
      sum(isnull(case when month(r.dt_prestacao) = 8  then d.vl_total_despesa else 0 end,0)) as 'Agosto',
      sum(isnull(case when month(r.dt_prestacao) = 9  then d.vl_total_despesa else 0 end,0)) as 'Setembro',
      sum(isnull(case when month(r.dt_prestacao) = 10 then d.vl_total_despesa else 0 end,0)) as 'Outubro',
      sum(isnull(case when month(r.dt_prestacao) = 11 then d.vl_total_despesa else 0 end,0)) as 'Novembro',
      sum(isnull(case when month(r.dt_prestacao) = 12 then d.vl_total_despesa else 0 end,0)) as 'Dezembro'

    into
      #ResumoDespesa
      
    from
      vw_prestacao_conta_despesa d
      inner join vw_resumo_prestacao_conta r on r.cd_prestacao = d.cd_prestacao
    where
      r.dt_prestacao between @dt_inicial and @dt_final
    group by
      d.cd_tipo_despesa
  
select
  @vl_total_prestacao = sum( vl_prestacao )
from
  #ResumoDespesa

select
  *,
  cast((vl_prestacao / @vl_total_prestacao ) * 100 as decimal(25,2)) as pc_prestacao
from
  #ResumoDespesa
order by
  nm_tipo_despesa
          
