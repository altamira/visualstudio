
-------------------------------------------------------------------------------
--sp_helptext pr_contabilizacao_baan_adiantamento
-------------------------------------------------------------------------------
--pr_contabilizacao_baan_adiantamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Contabilização do Financeiro para o Sistema BAAN
--Data             : 28.05.2007
--Alteração        : 05.06.2007
--                 : 14.09.2007 - Acertos gerais na procedure - Carlos Fernandes
-- 05.11.2007 - Mostrar somente os Adiantamentos Liberados - Carlos Fernandes
-- 09.11.2007 - Agrupamento do Crédito - Carlos Fernandes
-- 16.11.2007 - Acertos no Campo para Exportação - Carlos Fernandes
-------------------------------------------------------------------------------
create procedure pr_contabilizacao_baan_adiantamento
@ic_parametro    int      = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int      = 0

as

-------------------------------------------------------------------------------
--Débito da Solicitação de Adiantamento 
-------------------------------------------------------------------------------

--select * from solicitacao_adiantamento_contabil
--select * from funcionario
--select * from tipo_adiantamento
--select * from solicitacao_adiantamento

select
--   sa.cd_solicitacao,  
  --Débito

  d.cd_mascara_conta                                 as CONTA,
  --cc.cd_mascara_centro_custo            as SETOR,
  cast(isnull(cd_identificacao_funcionario,cd_registro_funcionario) as varchar) as SETOR,
  cast(null as varchar)                              as PROJETO,
  --cast(cc.cd_centro_custo as varchar)   as CCUSTO,
  --cast(cd_registro_funcionario as varchar) as CCUSTO,

  cast(null as varchar)                              as CCUSTO,

  isnull(a.vl_contab_adiantamento,0)                 as VALOR,

  'D'                                                as TIPO,
  cast(null as varchar)                              as FORNEC,
  cast(null as varchar)                              as CLIENTE,
  cast(rtrim(ltrim(a.nm_historico_contabil))+' '+
  rtrim(ltrim(f.nm_funcionario)) as varchar(40))     as HISTORICO

into
  #AdiantamentoBaanDebito
from
  Solicitacao_Adiantamento_Contabil a
  left outer join Solicitacao_Adiantamento sa on sa.cd_solicitacao  = a.cd_solicitacao
  left outer join plano_conta d               on d.cd_conta         = a.cd_conta_debito
  left outer join Centro_Custo cc             on cc.cd_centro_custo = sa.cd_centro_custo
  left outer join Funcionario f               on f.cd_funcionario   = sa.cd_funcionario

where
  a.dt_contab_adiantamento between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0      and
  isnull(a.ic_contabilizado,'N')='N' and
  isnull(sa.cd_moeda,0)=1            and        --Moeda R$ 
  sa.dt_liberacao_adiantamento is not null  and --Data de Liberação do Adiantamento
  sa.dt_financeiro_solicitacao is not null      --Data da Liberação do Financeiro

  
order by
  a.dt_contab_adiantamento

--select * from solicitacao_adiantamento
--select * from #AdiantamentoBaanDebito
--select * from Solicitacao_Adiantamento_Contabil
-------------------------------------------------------------------------------
--Crédito da Solicitação de Adiantamento
-------------------------------------------------------------------------------

--select * from tipo_adiantamento

select

--   sa.cd_solicitacao,  

  --Crédito

  c.cd_mascara_conta                                         as CONTA,
--  cc.cd_mascara_centro_custo            as SETOR,
  cast(case when sa.cd_tipo_adiantamento = 2 then
    'CAIXA'
  else
    ''
  end as varchar)                                            as SETOR,

  cast(null as varchar)                                      as PROJETO,
  cast(null as varchar)                                      as CCUSTO,
--  cast(cc.cd_centro_custo as varchar)   as CCUSTO,
  isnull(a.vl_contab_adiantamento,0)                         as VALOR,
  'C'                                                        as TIPO,
  cast(null as varchar)                                      as FORNEC,
  cast(null as varchar)                                      as CLIENTE,
  cast(rtrim(ltrim(a.nm_historico_contabil)) as varchar(40)) as HISTORICO

into
  #AdiantamentoBaanCredito
from
  Solicitacao_Adiantamento_Contabil a
  left outer join Solicitacao_Adiantamento sa on sa.cd_solicitacao  = a.cd_solicitacao
  left outer join plano_conta c               on c.cd_conta         = a.cd_conta_credito
  left outer join Centro_Custo cc             on cc.cd_centro_custo = sa.cd_centro_custo

where
  a.dt_contab_adiantamento between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0 and
  isnull(a.ic_contabilizado,'N')='N' and
  isnull(sa.cd_moeda,0)         = 1  and --Moeda R$
  sa.dt_liberacao_adiantamento is not null and
  sa.dt_financeiro_solicitacao is not null  --Data da Liberação do Financeiro


order by
  a.dt_contab_adiantamento

--Agrupamento do Crédito

select
--  cd_solicitacao,
  CONTA,
  SETOR,
  PROJETO,
  CCUSTO,
  SUM(ISNULL(VALOR,0))                                AS VALOR,
  TIPO,
  cast(MAX(FORNEC)  as varchar)                       AS FORNEC,
  cast(MAX(CLIENTE) as varchar)                       AS CLIENTE,   
  cast('ADIANTAMENTO DESPESAS VIAGEM' as varchar(40)) AS HISTORICO
into
  #ContabCreditoAdiantamento
from 
  #AdiantamentoBaanCredito

GROUP BY
--  cd_solicitacao,
  CONTA,
  SETOR,
  PROJETO,
  CCUSTO,
  TIPO

--Montagem da Tabela Débito/Crédito

select
--   CONTA,
--   CAST(SETOR AS VARCHAR) AS SETOR,
--   PROJETO,
--   CCUSTO,
--   VALOR,
--   TIPO,
--   FORNEC,
--   CLIENTE,
--   HISTORICO

*

from
  #AdiantamentoBaanDebito
union all
  select * from #ContabCreditoAdiantamento


