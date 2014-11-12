
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_prestacao_conta_funcionario_fechamento
-------------------------------------------------------------------------------
--pr_resumo_prestacao_conta_funcionario_fechamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Prestação de Conta por Funcionário
--Data             : 19.11.2007
--Alteração        : 25.01.2008 - Mostrar o Valor Total das Despesas - Carlos Fernandes
-- 28.04.2008 - Ajuste do Total de Despesas - Carlos Fernandes
-- 11.08.2008 - Ajuste do Fornecedor - Carlos Fernandes
---------------------------------------------------------------------------------------
create procedure pr_resumo_prestacao_conta_funcionario_fechamento
@ic_tipo_consulta char(1)  = 'E', --Emissão / Competência
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_departamento  int      = 0,
@cd_cedntro_custo int      = 0,
@cd_projeto       int      = 0,
@cd_tipo_viagem   int      = 0

as

declare @vl_total_prestacao decimal(25,2)

set @vl_total_prestacao = 0.00

    select
      r.cd_funcionario,
      max(r.nm_funcionario)                                      as nm_funcionario,
      max(r.nm_departamento)                                     as nm_departamento,
      max(r.nm_centro_custo)                                     as nm_centro_custo,
      count(*)                                                   as qt_prestacao,
      sum( isnull(r.vl_prestacao_corrigido,0)  )                 as vl_prestacao,
      sum( isnull(r.vl_pagamento_empresa,0)    )                 as vl_pagamento_empresa,
      sum( isnull(r.vl_pagamento_funcionario,0))                 as vl_pagamento_funcionario,
      sum( isnull(r.vl_total_despesa_prestacao,0))               as vl_despesa_prestacao,
      sum( dbo.fn_total_despesa_prestao_conta( r.cd_prestacao )) as TotalDespesa,
      sum( 0.00 )                                                as TotalAdiantamento,
      sum( 0.00 )                                                as TotalReembolsavel,
      sum( 0.00 )                                                as TotalNaoReembolsavel
 
    into
      #ResumoFuncionario
      
    from
      vw_resumo_prestacao_conta r
    where
      r.dt_fechamento_prestacao between @dt_inicial and @dt_final and
      r.cd_departamento = case when @cd_departamento = 0 then r.cd_departamento else @cd_departamento end and
      r.cd_conta = 0
    group by
      r.cd_funcionario


---------------------------------------------------------------------------------------
--Verifica se existem funcionários em Prestação de contas de fornecedor
---------------------------------------------------------------------------------------

insert into 
  #ResumoFuncionario
select
  r.cd_funcionario,
  max(r.nm_funcionario)                                          as nm_funcionario,
  max(r.nm_departamento)                                         as nm_departamento,
  max(r.nm_centro_custo)                                         as nm_centro_custo,
  count(*)                                                       as qt_prestacao,
  sum( r.vl_prestacao )                                          as vl_prestacao,
  sum( r.vl_pagamento_empresa )                                  as vl_pagamento_empresa,
  sum( isnull(r.vl_pagamento_funcionario,0)  )                   as vl_pagamento_funcionario,
  sum( isnull(r.TotalDespesa,0))                                 as vl_despesa_prestacao,
  sum( TotalDespesa )                                            as TotalDespesa,
  sum( 0.00 )                                                    as TotalAdiantamento,
  sum( 0.00 )                                                    as TotalReembolsavel,
  sum( 0.00 )                                                    as TotalNaoReembolsavel

from
  vw_resumo_prestacao_conta_funcionario r
where
  r.dt_fechamento_prestacao between @dt_inicial and @dt_final and
  r.cd_departamento = case when @cd_departamento = 0 then r.cd_departamento else @cd_departamento end 

group by
  r.cd_funcionario

  

  
select
  @vl_total_prestacao = sum( vl_prestacao )
from
  #ResumoFuncionario

select
  *,
  cast((vl_prestacao / @vl_total_prestacao ) * 100 as decimal(25,2)) as pc_prestacao
from
  #ResumoFuncionario
order by
  nm_funcionario
          
