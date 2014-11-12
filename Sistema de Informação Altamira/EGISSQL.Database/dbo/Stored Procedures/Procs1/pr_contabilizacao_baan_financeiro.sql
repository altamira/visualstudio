
-------------------------------------------------------------------------------
--sp_helptext pr_contabilizacao_baan_financeiro
-------------------------------------------------------------------------------
--pr_contabilizacao_baan_financeiro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Contabilização do Financeiro para o Sistema BAAN
--Data             : 28.05.2007
--Alteração        : 05.06.2007
--                 : 
--                 : 
-------------------------------------------------------------------------------
create procedure pr_contabilizacao_baan_financeiro
@ic_parametro    int      = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int      = 0

as

-------------------------------------------------------------------------------
--Débito da Solicitação de Adiantamento 
-------------------------------------------------------------------------------

--select * from solicitacao_adiantamento_contabil

select
  
  --Débito

  d.cd_mascara_conta                    as CONTA,
  cc.cd_mascara_centro_custo            as SETOR,
  cast(null as varchar)                 as PROJETO,
  cast(null as varchar)                 as CCUSTO,
  a.vl_contab_adiantamento              as VALOR,
  'D'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  rtrim(ltrim(a.nm_historico_contabil)) as HISTORICO

into
  #AdiantamentoBaanDebito
from
  Solicitacao_Adiantamento_Contabil a
  left outer join Solicitacao_Adiantamento sa on sa.cd_solicitacao  = a.cd_solicitacao
  left outer join plano_conta d               on d.cd_conta         = a.cd_conta_debito
  left outer join Centro_Custo cc             on cc.cd_centro_custo = sa.cd_centro_custo

where
  a.dt_contab_adiantamento between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0
order by
  a.dt_contab_adiantamento

--select * from #AdiantamentoBaanDebito

-------------------------------------------------------------------------------
--Débito da Prestação de Contas
-------------------------------------------------------------------------------

--select * from prestacao_conta_contabil

select
  
  --Débito

  d.cd_mascara_conta                    as CONTA,
  cc.cd_mascara_centro_custo            as SETOR,
  cast(null as varchar)                 as PROJETO,
  cast(null as varchar)                 as CCUSTO,
  a.vl_contab_prestacao                 as VALOR,
  'D'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  rtrim(ltrim(a.nm_historico_contabil)) as HISTORICO

into
  #FinanceiroBaanDebito
from
  Prestacao_Conta_Contabil a
  left outer join plano_conta d   on d.cd_conta         = a.cd_conta_debito
  left outer join Centro_Custo cc on cc.cd_centro_custo = a.cd_centro_custo

where
  a.dt_contab_prestacao between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0
order by
  a.dt_contab_prestacao


--select * from #FinanceiroBaanDebito

-------------------------------------------------------------------------------
--Crédito da Solicitação de Adiantamento
-------------------------------------------------------------------------------

select

  --Crédito

  c.cd_mascara_conta                    as CONTA,
  cc.cd_mascara_centro_custo            as SETOR,
  cast(null as varchar)                 as PROJETO,
  cast(null as varchar)                 as CCUSTO,
  a.vl_contab_adiantamento              as VALOR,
  'C'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  rtrim(ltrim(a.nm_historico_contabil)) as HISTORICO

into
  #AdiantamentoBaanCredito
from
  Solicitacao_Adiantamento_Contabil a
  left outer join Solicitacao_Adiantamento sa on sa.cd_solicitacao  = a.cd_solicitacao
  left outer join plano_conta c               on c.cd_conta         = a.cd_conta_credito
  left outer join Centro_Custo cc             on cc.cd_centro_custo = sa.cd_centro_custo

where
  a.dt_contab_adiantamento between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0
order by
  a.dt_contab_adiantamento

--select * from #AdiantamentoBaanCredito

-------------------------------------------------------------------------------
--Crédito da Prestação de Contas
-------------------------------------------------------------------------------

select

  --Crédito

  c.cd_mascara_conta                    as CONTA,
  cc.cd_mascara_centro_custo            as SETOR,
  cast(null as varchar)                 as PROJETO,
  cast(null as varchar)                 as CCUSTO,
  a.vl_contab_prestacao                 as VALOR,
  'C'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  rtrim(ltrim(a.nm_historico_contabil)) as HISTORICO

into
  #FinanceiroBaanCredito
from
  Prestacao_Conta_Contabil a
  left outer join plano_conta c   on c.cd_conta         = a.cd_conta_credito
  left outer join Centro_Custo cc on cc.cd_centro_custo = a.cd_centro_custo

where
  a.dt_contab_prestacao between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0
order by
  a.dt_contab_prestacao

--Montagem da Tabela Débito/Crédito

select
  *
from
  #AdiantamentoBaanDebito
union all
  select * from #AdiantamentoBaanCredito
union all
  select * from #FinanceiroBaanDebito
union all
  select * from #FinanceiroBaanCredito
    







 
