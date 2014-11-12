
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_prestacao_conta_departamento_fechamento
-------------------------------------------------------------------------------
--pr_resumo_prestacao_conta_departamento_fechamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Prestação de Conta por Departamento
--Data             : 19.11.2007
--Alteração        : 25.01.2008 - Total da Despesas - Carlos Fernandes
-- 25.04.2008 - Ajuste do Resumo Valor Total de Despesas - Carlos 
-- 04.07.2008 - data do Fechamento - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_resumo_prestacao_conta_departamento_fechamento
@ic_tipo_consulta char(1)  = 'E', --Emissão / Competência
@dt_inicial       datetime = '',
@dt_final         datetime = ''

as

declare @vl_total_prestacao decimal(25,2)

set @vl_total_prestacao = 0.00

    select
      r.cd_departamento,
      max(r.nm_departamento)                                     as nm_departamento,
      count(*)                                                   as qt_prestacao,
      sum( isnull(r.vl_prestacao_corrigido,0) )                  as vl_prestacao,
      sum( isnull(r.vl_pagamento_empresa,0))                     as vl_pagamento_empresa,
      sum( isnull(r.vl_pagamento_funcionario,0))                 as vl_pagamento_funcionario,
      sum( isnull(r.vl_total_despesa_prestacao,0))               as vl_despesa_prestacao,
      sum( dbo.fn_total_despesa_prestao_conta( r.cd_prestacao )) as TotalDespesa,
      sum( 0.00 )                                                as TotalAdiantamento,
      sum( 0.00 )                                                as TotalReembolsavel,
      sum( 0.00 )                                                as TotalNaoReembolsavel


    into
      #ResumoDepartamento
      
    from
      vw_resumo_prestacao_conta r
    where
      r.dt_fechamento_prestacao between @dt_inicial and @dt_final
    group by
      r.cd_departamento
  
select
  @vl_total_prestacao = sum( vl_prestacao )
from
  #ResumoDepartamento

select
  *,
  cast((vl_prestacao / @vl_total_prestacao ) * 100 as decimal(25,2)) as pc_prestacao
from
  #ResumoDepartamento
order by
  nm_departamento
          
