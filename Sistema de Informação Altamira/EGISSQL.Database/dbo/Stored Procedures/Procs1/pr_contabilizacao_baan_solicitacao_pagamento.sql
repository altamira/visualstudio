
-------------------------------------------------------------------------------
--sp_helptext pr_contabilizacao_baan_solicitacao_pagamento
-------------------------------------------------------------------------------
--pr_contabilizacao_baan_pagamento
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
-- 05.11.2007 - Mostrar somente os pagamentos Liberados - Carlos Fernandes
-- 14.11.2007 - Histórico - Carlos Fernandes
-------------------------------------------------------------------------------
create procedure pr_contabilizacao_baan_solicitacao_pagamento
@ic_parametro    int      = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int      = 0

as

-------------------------------------------------------------------------------
--Débito da Solicitação de pagamento 
-------------------------------------------------------------------------------

--select * from solicitacao_pagamento_contabil
--select * from funcionario
--select * from tipo_pagamento
--select * from solicitacao_pagamento

select
  
  --Débito

  d.cd_mascara_conta                    as CONTA,
  --cc.cd_mascara_centro_custo            as SETOR,
  --cast(isnull(cd_identificacao_funcionario,cd_registro_funcionario) as varchar) as SETOR,
  case when isnull(td.ic_centro_custo_tipo_despesa,'N')='S' 
  then
     cast(cc.sg_centro_custo as varchar) 
  else
     cast('' as varchar) 
  end                                   as SETOR,

  cast(null as varchar)                 as PROJETO,

--  cast(cc.cd_centro_custo as varchar)   as CCUSTO,
  --cast(cd_registro_funcionario as varchar) as CCUSTO,

  cast(null as varchar)                 as CCUSTO,

  isnull(a.vl_contab_pagamento,0)       as VALOR,
  'D'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  cast(rtrim(ltrim(a.nm_historico_contabil)) as varchar(40)) as HISTORICO

into
  #pagamentoBaanDebito
from
  Solicitacao_Pagamento_Contabil a
  left outer join Solicitacao_Pagamento sa             on sa.cd_solicitacao       = a.cd_solicitacao
  left outer join plano_conta d                        on d.cd_conta              = a.cd_conta_debito
  left outer join Centro_Custo cc                      on cc.cd_centro_custo      = sa.cd_centro_custo
  left outer join Funcionario f                        on f.cd_funcionario        = sa.cd_funcionario
  left outer join Solicitacao_Pagamento_Composicao spc on spc.cd_solicitacao      = a.cd_solicitacao and
                                                          spc.cd_item_solicitacao = a.cd_item_solicitacao 
  left outer join Tipo_Despesa td                      on td.cd_tipo_despesa      = spc.cd_tipo_despesa
where
  a.dt_contab_pagamento between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0      and
  isnull(a.ic_contabilizado,'N')='N'
-- and isnull(sa.cd_moeda,0)=1                --Moeda R$ 
  and sa.dt_liberacao_pagamento is not null   --Data de Liberação do pagamento
  and sa.dt_financeiro_solicitacao is not null  --Data da Liberação do Financeiro

  
order by
  a.dt_contab_pagamento

--select * from solicitacao_pagamento
--select * from #pagamentoBaanDebito
--select * from Solicitacao_pagamento_Contabil
-------------------------------------------------------------------------------
--Crédito da Solicitação de pagamento
-------------------------------------------------------------------------------

--select * from tipo_pagamento

select

  --Crédito

  c.cd_mascara_conta                    as CONTA,
--  cc.cd_mascara_centro_custo            as SETOR,
  case when sa.cd_tipo_pagamento = 2 then
    'CAIXA'
  else
    ''
  end                                   as SETOR,

  cast(null as varchar)                 as PROJETO,
  cast(null as varchar)                 as CCUSTO,
--  cast(cc.cd_centro_custo as varchar)   as CCUSTO,
  a.vl_contab_pagamento              as VALOR,
  'C'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,
  cast(rtrim(ltrim(a.nm_historico_contabil)) as varchar(40)) as HISTORICO

into
  #pagamentoBaanCredito
from
  Solicitacao_Pagamento_Contabil a
  left outer join Solicitacao_Pagamento sa on sa.cd_solicitacao  = a.cd_solicitacao
  left outer join plano_conta c               on c.cd_conta         = a.cd_conta_credito
  left outer join Centro_Custo cc             on cc.cd_centro_custo = sa.cd_centro_custo

where
  a.dt_contab_pagamento between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0 and
  isnull(a.ic_contabilizado,'N')='N' 
--and isnull(sa.cd_moeda,0)         = 1  --Moeda R$
  and sa.dt_liberacao_pagamento is not null
  and sa.dt_financeiro_solicitacao is not null  --Data da Liberação do Financeiro


order by
  a.dt_contab_pagamento

--Montagem da Tabela Débito/Crédito

select
  *
from
  #pagamentoBaanDebito
union all
  select * from #pagamentoBaanCredito

