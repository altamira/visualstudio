
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_prestacao_conta_projeto_despesa
-------------------------------------------------------------------------------
--pr_resumo_prestacao_conta_projeto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Prestação de Conta por Projeto
--Data             : 19.11.2007
--Alteração        : 25.01.2008 - Total de despesas - Carlos Fernandes
--28.04.2008 - Ajuste Gerais / Total Despesas - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_resumo_prestacao_conta_projeto_despesa
@ic_tipo_consulta char(1)  = 'E', --Emissão / Competência
@dt_inicial       datetime = '',
@dt_final         datetime = ''

as

--select * from vw_resumo_prestacao_conta

declare @vl_total_prestacao decimal(25,2)

set @vl_total_prestacao = 0.00

    select
      --r.cd_projeto_viagem,
      max(r.cd_projeto_viagem)                                   as cd_projeto_viagem, 
      r.nm_projeto_consistido                                    as nm_projeto_viagem,
      count(*)                                                   as qt_prestacao,
      sum( isnull(r.vl_prestacao_corrigido,0) )                  as vl_prestacao,
      sum( isnull(r.vl_pagamento_empresa,0))                     as vl_pagamento_empresa,
      sum( isnull(r.vl_pagamento_funcionario,0))                 as vl_pagamento_funcionario,
      sum( isnull(r.vl_total_despesa_prestacao,0))               as vl_despesa_prestacao,
      --sum( isnull(d.vl_total_despesa,0))                         as vl_total_despesa,
      --sum( isnull(d.vl_total_despesa,0))                         as TotalDespesa,
      --sum( dbo.fn_total_despesa_prestao_conta( r.cd_prestacao )) as vl_total_despesa,
      --sum( dbo.fn_total_despesa_prestao_conta( r.cd_prestacao )) as TotalDespesa,
      sum( isnull(r.vl_total_despesa,0) )                        as vl_total_despesa,
      sum( isnull(r.vl_total_despesa,0) )                        as TotalDespesa,
      sum( 0.00 )                                                as TotalAdiantamento,
      sum( 0.00 )                                                as TotalReembolsavel,
      sum( 0.00 )                                                as TotalNaoReembolsavel

    into
      #ResumoProjetoDespesa
      
    from
      vw_resumo_prestacao_conta_composicao r 
    where
      r.dt_prestacao between @dt_inicial and @dt_final and
      isnull(r.ic_reembolsavel_despesa,'S') = 'S'

    group by
      r.nm_projeto_consistido
  
select
  @vl_total_prestacao = sum( vl_total_despesa )
from
  #ResumoProjetoDespesa

select
  *,
  cast((vl_prestacao / @vl_total_prestacao ) * 100 as decimal(25,2)) as pc_prestacao
from
  #ResumoProjetoDespesa
order by
  nm_projeto_viagem
          
