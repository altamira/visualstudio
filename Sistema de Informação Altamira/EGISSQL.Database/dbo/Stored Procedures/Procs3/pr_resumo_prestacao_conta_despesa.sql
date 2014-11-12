
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_prestacao_conta_despesa
-------------------------------------------------------------------------------
--pr_resumo_prestacao_conta_despesa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Prestação de Conta por Centro de Custo
--Data             : 19.11.2007
--Alteração        : 28.04.2008 - Ajuste da procedure - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_resumo_prestacao_conta_despesa
@ic_tipo_consulta char(1)  = 'E', --Emissão / Competência
@dt_inicial       datetime = '',
@dt_final         datetime = ''

as

declare @vl_total_prestacao decimal(25,2)

set @vl_total_prestacao = 0.00

    select
      d.cd_tipo_despesa,
      max(d.nm_tipo_despesa)                                     as nm_tipo_despesa,
      count(*)                                                   as qt_prestacao,
      sum( isnull(r.vl_prestacao_corrigido,0) )                  as vl_prestacao,
      sum( isnull(r.vl_pagamento_empresa,0))                     as vl_pagamento_empresa,
      sum( isnull(r.vl_pagamento_funcionario,0))                 as vl_pagamento_funcionario,
      sum( isnull(d.vl_total_despesa,0))                         as vl_total_despesa,
      sum( dbo.fn_total_despesa_prestao_conta( r.cd_prestacao )) as TotalDespesa,
      sum( 0.00 )                                                as TotalAdiantamento,
      sum( 0.00 )                                                as TotalReembolsavel,
      sum( 0.00 )                                                as TotalNaoReembolsavel


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
          
