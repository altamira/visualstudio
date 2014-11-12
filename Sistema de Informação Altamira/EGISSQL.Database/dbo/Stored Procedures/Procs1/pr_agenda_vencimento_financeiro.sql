--use egissql
-------------------------------------------------------------------------------
--sp_helptext pr_agenda_vencimento_financeiro
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Agenda de Vencimentos do Movimento Financeiro
--                   Gerado pelas Prestações de Contas, Solicitações de Pagamento
--
--Data             : 12.05.2008
--Alteração        : 
-- 09.06.2008 - Ajuste do Carlos - Carlos Fernandes
-- 04.07.2008 - Data de Vencimento da Solicitação de Pagamento - Carlos Fernandes
-- 01.09.2008 - Número da Nota de Entrada - Carlos Fernandes
----------------------------------------------------------------------------------
create procedure pr_agenda_vencimento_financeiro
@dt_inicial datetime,
@dt_final   datetime
as

--select * from prestacao_conta_composicao

--Prestação de Contas

select
  max('PC')                              as nm_tipo_documento,
  max(f.nm_funcionario)                  as nm_funcionario,
  cp.dt_vencimento_documento,
  max(m.sg_moeda)                        as sg_moeda,
  sum( isnull(cp.vl_total_despesa,0))    as vl_total_despesa,
  pc.cd_prestacao,
  pc.dt_prestacao,
  max(td.nm_tipo_despesa)                as nm_tipo_despesa,
  max(case when isnull(fc.nm_funcionario,'')<>''
  then
    fc.nm_funcionario
  else
   f.nm_funcionario
  end)                                   as nm_funcionario_composicao,
  max(pc.cd_nota_entrada)                as cd_nota_entrada  
into
  #VencimentoPrestacao  
from
  Prestacao_Conta_Composicao   cp with (nolock)
  inner join Prestacao_Conta   pc with (nolock) on pc.cd_prestacao    = cp.cd_prestacao
  left outer join Tipo_Despesa td with (nolock) on td.cd_tipo_despesa = cp.cd_tipo_despesa
  left outer join Funcionario  fc with (nolock) on fc.cd_funcionario  = cp.cd_funcionario_composicao
  left outer join Funcionario  f  with (nolock) on f.cd_funcionario   = pc.cd_funcionario
  left outer join Moeda        m  with (nolock) on m.cd_moeda         = pc.cd_moeda

where
  cp.dt_vencimento_documento between @dt_inicial and @dt_final 
  --and pc.dt_fechamento_prestacao is null
  and isnull(f.cd_conta,0)<>0
group by
  cp.dt_vencimento_documento,
  pc.cd_prestacao,
  pc.dt_prestacao

--order by
--  cp.dt_vencimento_documento desc


--Solicitação de Pagamento
--select * from solicitacao_pagamento

select
  'SP'                                       as nm_tipo_documento,
  sp.nm_favorecido_solicitacao               as nm_funcionario,
  isnull(sp.dt_vencimento,sp.dt_necessidade) as dt_vencimento_documento,
  m.sg_moeda,
  isnull(sp.vl_pagamento,0)                  as vl_total_despesa,
  sp.cd_solicitacao                          as cd_prestacao,
  sp.dt_solicitacao                          as dt_prestacao,
  fp.nm_finalidade_pagamento                 as nm_tipo_despesa,
  case when isnull(fc.nm_funcionario,'')<>''
  then
    fc.nm_funcionario
  else
   sp.nm_favorecido_solicitacao
  end                                        as nm_funcionario_composicao,
  0                                          as cd_nota_entrda
into
  #VencimentoSolicitacao
from
  Solicitacao_Pagamento   sp              with (nolock)
  left outer join Finalidade_Pagamento fp with (nolock) on fp.cd_finalidade_pagamento = sp.cd_finalidade_pagamento
  left outer join Funcionario  fc         with (nolock) on fc.cd_funcionario          = sp.cd_funcionario
  left outer join Moeda        m          with (nolock) on m.cd_moeda                 = sp.cd_moeda
where
  sp.dt_necessidade between @dt_inicial and @dt_final and
  sp.dt_conf_solicitacao is null

order by
  isnull(sp.dt_vencimento,sp.dt_necessidade) desc


select
 *
from 
 #VencimentoPrestacao
union all
 select * from #VencimentoSolicitacao
order by
  dt_vencimento_documento desc

