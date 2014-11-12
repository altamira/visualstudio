﻿
-------------------------------------------------------------------------------
--sp_helptext pr_contabilizacao_baan_autorizacao_pagamento
-------------------------------------------------------------------------------
--pr_contabilizacao_baan_acerto_prestacao_conta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Contabilização do Financeiro para o Sistema BAAN
--                   Autorização de Pagamento
--
--Data             : 28.05.2007
--Alteração        : 05.06.2007
--                 : 06.06.2007 - Prestação de Contas
--                 : 14.09.2007 - Acerto do Funcionário - Carlos Fernandes
--                   24.09.2007 - Complemento - Carlos Fernandes.
--                   27.09.2007 - Flag para controle da confirmação da contabilização
--                   02.10.2007 - Nova Procedure - Carlos Fernandes 
--                   12.11.2007 - Funcionário no Histórico - Carlos Fernandes
-- 14.11.2007 - Histórico - Carlos Fernandes
-- 11.08.2008 - Não mostrar a contabilização dos fornecedores - Carlos Fernandes
--------------------------------------------------------------------------------
create procedure pr_contabilizacao_baan_autorizacao_pagamento
@ic_parametro    int      = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int      = 0

as


-------------------------------------------------------------------------------
--Débito da Prestação de Contas
-------------------------------------------------------------------------------

--select * from prestacao_conta
--select * from prestacao_conta_contabil

select
--  a.cd_ap,
--  a.dt_contab_ap,
--  p.cd_prestacao,  

  --Débito

  d.cd_mascara_conta                    as CONTA,

  cast(isnull(f.cd_identificacao_funcionario,f.cd_registro_funcionario) as varchar) as SETOR,

  --cc.cd_mascara_centro_custo            as SETOR,
  --cast(isnull(f.cd_identificacao_funcionario,f.cd_registro_funcionario) as varchar) as SETOR,

--   case when d.cd_mascara_conta = '12410001' then
--     'CAIXA'
--   else
--     case when isnull(a.cd_projeto_viagem,0)>0 and isnull(proj.ic_setor_projeto,'S')='S'then
--        cc.sg_centro_custo
--     else
--       case when isnull(a.cd_projeto_viagem,0)>0 and isnull(proj.ic_setor_projeto,'S')='N'then
--        cast(null as varchar)
--       else
--         --cast(isnull(f.cd_identificacao_funcionario,f.cd_registro_funcionario) as varchar) 
--        cc.sg_centro_custo
--       end
--    end
-- 
--   end                                   as SETOR,

  case when isnull(a.cd_projeto_viagem,0)>0 and isnull(proj.ic_projeto_projeto,'S')='S' then
    isnull(a.nm_projeto_viagem,proj.nm_projeto_viagem)      
  else
    cast(null as varchar)
  end                                   as PROJETO,

  case when isnull(a.cd_projeto_viagem,0)>0 and isnull(proj.ic_centro_custo_projeto,'S')='S' then
    'CGS'
  else
    --cc.sg_centro_custo
    cast(null as varchar) 
  end                                                   as CCUSTO,

  isnull(a.vl_contab_ap,0)                              as VALOR,
  'D'                                                   as TIPO,
  cast(null as varchar)                                 as FORNEC,
  cast(null as varchar)                                 as CLIENTE,
  cast(rtrim(ltrim(a.nm_historico_contabil))+' '+
  rtrim(ltrim(f.nm_funcionario))        as varchar(40)) as HISTORICO

into
  #FinanceiroBaanDebito
from
  Autorizacao_Pagamento_Contabil a    with (nolock) 
  left outer join Prestacao_Conta p   on p.cd_prestacao         = a.cd_prestacao
  left outer join plano_conta d       on d.cd_conta             = a.cd_conta_debito
  left outer join Centro_Custo cc     on cc.cd_centro_custo     = isnull(a.cd_centro_custo,p.cd_centro_custo)
  left outer join Funcionario f       on f.cd_funcionario       = p.cd_funcionario
  left outer join Projeto_Viagem proj on proj.cd_projeto_viagem = a.cd_projeto_viagem
 where
  a.dt_contab_ap between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0         and
  isnull(a.ic_contabilizado,'N') = 'N'  and
  isnull(a.ic_cartao_credito,'N')= 'N'  and
  p.dt_liberacao_prestacao is not null  and
  isnull(f.cd_conta,0)=0

order by
  a.dt_contab_ap

--select * from #FinanceiroBaanDebito

-------------------------------------------------------------------------------
--Crédito da Prestação de Contas
-------------------------------------------------------------------------------

select
--  a.cd_ap,
--  a.dt_contab_ap,
  p.cd_prestacao,  

  --Crédito

  c.cd_mascara_conta                    as CONTA,
--  cast(isnull(f.cd_identificacao_funcionario,f.cd_registro_funcionario) as varchar) as SETOR,

  case when c.cd_mascara_conta = '12410001' then
    'CAIXA'
  else
    case when isnull(a.cd_projeto_viagem,0)>0 and isnull(proj.ic_setor_projeto,'S')='S'then
       cc.sg_centro_custo
    else
      case when isnull(a.cd_projeto_viagem,0)>0 and isnull(proj.ic_setor_projeto,'S')='N'then
       cast(null as varchar)
      else
        --cast(isnull(f.cd_identificacao_funcionario,f.cd_registro_funcionario) as varchar) 
       cc.sg_centro_custo
      end
   end

  end                                   as SETOR,

--  cc.cd_mascara_centro_custo            as SETOR,
--   case when sa.cd_tipo_adiantamento = 2 then
--     'CAIXA'
--   else
--     ''
--   end                                   as SETOR,

  cast(null as varchar)                                                 as PROJETO,
  cast(null as varchar)                                                 as CCUSTO,
  isnull(a.vl_contab_ap,0)                                              as VALOR,
  'C'                                                                   as TIPO,
  cast(null as varchar)                                                 as FORNEC,
  cast(null as varchar)                                                 as CLIENTE,
  cast(rtrim(ltrim(isnull(a.nm_historico_contabil,''))) as varchar(40)) as HISTORICO

into
  #FinanceiroBaanCredito
from
  Autorizacao_Pagamento_Contabil a
  left outer join Prestacao_Conta p     on p.cd_prestacao         = a.cd_prestacao
  left outer join plano_conta c         on c.cd_conta             = a.cd_conta_credito
  left outer join Centro_Custo cc       on cc.cd_centro_custo     = a.cd_centro_custo
  left outer join Funcionario f         on f.cd_funcionario       = p.cd_funcionario
  left outer join Projeto_Viagem proj   on proj.cd_projeto_viagem = p.cd_projeto_viagem

where
  a.dt_contab_ap between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0       and
  isnull(a.ic_contabilizado,'N') = 'N' and
  isnull(a.ic_cartao_credito,'N')= 'N' and
  p.dt_liberacao_prestacao is not null and
  isnull(f.cd_conta,0)=0

order by
  a.dt_contab_ap


--Agrupamento do Crédito

--Agrupamento do Crédito

select
  CONTA,
  SETOR,
  PROJETO,
  CCUSTO,
  SUM(ISNULL(VALOR,0))                                AS VALOR,
  TIPO,
  MAX(FORNEC)                                         AS FORNEC,
  MAX(CLIENTE)                                        AS CLIENTE,   
  --cast('PC N.'+cast(max(cd_prestacao) as varchar(8)) as varchar(40)) AS HISTORICO
  cast('PGTO PC CONTAS' as varchar(40))               AS HISTORICO
into
  #ContabCreditoAutorizacao
from 
  #FinanceiroBaanCredito
GROUP BY
  CONTA,
  SETOR,
  PROJETO,
  CCUSTO,
  TIPO

--Montagem da Tabela Débito/Crédito

select
  *
from 
  #FinanceiroBaanDebito
union all
  select * from #ContabCreditoAutorizacao



-- select
--   *
-- from 
--   #FinanceiroBaanDebito
-- union all
--   select * from #FinanceiroBaanCredito

-- select
--   cd_prestacao,
--   CONTA,
--   SETOR,
--   PROJETO,
--   CCUSTO,
--   SUM(ISNULL(VALOR,0))         AS VALOR,
--   TIPO,
--   MAX(FORNEC)                  AS FORNEC,
--   MAX(CLIENTE)                 AS CLIENTE,   
--   'PRESTACAO CONTA N. '+cast(cd_prestacao as varchar(8)) as HISTORICO
-- into
--   #ContabDebito
-- from 
--   #FinanceiroBaanDebito 
-- GROUP BY
--   cd_prestacao,
--   CONTA,
--   SETOR,
--   PROJETO,
--   CCUSTO,
--   TIPO
-- 
-- select
--   *
-- from 
--   #ContabDebito
-- union all
--   select * from #FinanceiroBaanCredito

--select * from #ContabDebito
   

