
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_solicitacao_sem_aprovacao
-------------------------------------------------------------------------------
--pr_consulta_solicitacao_sem_aprovacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta das Solicitações de Sem Aprovação
--Data             : 26.11.2007
--Alteração        : 18.02.2008 - Ajustes - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_solicitacao_sem_aprovacao
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--Funcionario

select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  0                                  as cd_requisicao_viagem,
  cast(null as datetime)             as dt_requisicao_viagem,
  0.00                               as vl_adto_viagem,
  0                                  as cd_solicitacao,
  cast(null as datetime)             as dt_solicitacao,
  0.00                               as vl_adiantamento,
  0                                  as cd_prestacao,
  cast(null as datetime)             as dt_prestacao,
  0.00                               as vl_prestacao,
  cast(null as datetime)             as dt_fechamento_prestacao,
  cast(''   as varchar(40))          as nm_cartao_credito,
  cast(''   as varchar(40))          as nm_status,
  0.00                               as vl_saldo_funcionario,
  0.00                               as vl_pagamento_funcionario,
  0.00                               as vl_pagamento_empresa

into 
  #Funcionario
from
  Funcionario f with (nolock)
where
  isnull(f.cd_funcionario,0)>0 


--Requisição de Viagem
--select * from requisicao_viagem
--select * from status_requisicao
--select * from solicitacao_adiantamento

select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  rv.cd_requisicao_viagem,
  rv.dt_requisicao_viagem,
  isnull(rv.vl_adto_viagem,0)        as vl_adto_viagem,
  sa.cd_solicitacao                  as cd_solicitacao,
  sa.dt_solicitacao                  as dt_solicitacao,
  isnull(sa.vl_adiantamento,0)       as vl_adiantamento,
  isnull(sa.cd_prestacao,0)          as cd_prestacao,
  pc.dt_prestacao                     as dt_prestacao,
  pc.vl_prestacao * case when pc.vl_prestacao<0 then -1 else 1 end    as vl_prestacao,
  --cast(null as datetime)             as dt_fechamento_prestacao,
  pc.dt_fechamento_prestacao          as dt_fechamento_prestacao,
  --cast(''   as varchar(40))          as nm_cartao_credito,
  tcc.nm_cartao_credito              as nm_cartao_credito,
  --cast(''   as varchar(40))          as nm_status,

  cast(case when pc.ic_status_prestacao = 'F' 
  then
    'Fechada'
  else
    case when pc.ic_status_prestacao = 'C' then 'Contabilizada'
    else
      'Aberta' end 
  end as varchar(40))                as nm_status,

  case when pc.ic_status_prestacao = 'C' or pc.ic_status_prestacao = 'F' then
     0.00                              
  else
     sa.vl_adiantamento
  end                                as vl_saldo_funcionario,
  case when pc.ic_tipo_deposito_prestacao='F' 
  then
    pc.vl_prestacao
  else
    0.00
  end                                as vl_pagamento_funcionario,
  case when pc.ic_tipo_deposito_prestacao='E'
  then
    pc.vl_prestacao * -1
  else
    0.00
  end                                as vl_pagamento_empresa


into
  #RequisicaoViagem
from
  Funcionario f with (nolock)
  left outer join Requisicao_Viagem rv        with (nolock) on rv.cd_funcionario       = f.cd_funcionario
  left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_requisicao_viagem = rv.cd_requisicao_viagem
  left outer join Prestacao_Conta pc          with (nolock) on pc.cd_prestacao         = sa.cd_prestacao
  left outer join Tipo_Cartao_Credito tcc     with (nolock) on tcc.cd_cartao_credito   = pc.cd_cartao_credito

where
  isnull(rv.cd_requisicao_viagem,0)>0 and
  isnull(rv.cd_funcionario,0)>0       and
  rv.cd_requisicao_viagem not in ( select cd_requisicao_viagem from requisicao_viagem_aprovacao )  

--Solicitação Adiantamento
--select * from solicitacao_adiantamento

select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  0                                  as cd_requisicao_viagem,
  cast(null as datetime)             as dt_requisicao_viagem,
  0.00                               as vl_adto_viagem,
  sa.cd_solicitacao                  as cd_solicitacao,
  sa.dt_solicitacao                  as dt_solicitacao,
  isnull(sa.vl_adiantamento,0)       as vl_adiantamento,
  isnull(sa.cd_prestacao,0)          as cd_prestacao,
  pc.dt_prestacao                    as dt_prestacao,
    pc.vl_prestacao * case when pc.vl_prestacao<0 then -1 else 1 end    
                                     as vl_prestacao,
  --cast(null as datetime)             as dt_fechamento_prestacao,
  pc.dt_fechamento_prestacao          as dt_fechamento_prestacao,
  --cast(''   as varchar(40))          as nm_cartao_credito,
  tcc.nm_cartao_credito              as nm_cartao_credito,
  --cast(''   as varchar(40))          as nm_status,
  cast(case when pc.ic_status_prestacao = 'F' 
  then
    'Fechada'
  else
    case when pc.ic_status_prestacao = 'C' then 'Contabilizada'
    else
      'Aberta' end 
  end as varchar(40))                as nm_status,

  case when pc.ic_status_prestacao = 'C' or pc.ic_status_prestacao = 'F' then
     0.00                              
  else
     sa.vl_adiantamento
  end                                as vl_saldo_funcionario,
  case when pc.ic_tipo_deposito_prestacao='F' 
  then
    pc.vl_prestacao
  else
    0.00
  end                                as vl_pagamento_funcionario,
  case when pc.ic_tipo_deposito_prestacao='E'
  then
    pc.vl_prestacao * -1
  else
    0.00
  end                                as vl_pagamento_empresa


into 
  #Adiantamento
from
  Funcionario f with (nolock) 
  left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_funcionario     = f.cd_funcionario
  left outer join Prestacao_Conta pc          with (nolock) on pc.cd_prestacao       = sa.cd_prestacao
  left outer join Tipo_Cartao_Credito tcc     with (nolock) on tcc.cd_cartao_credito = pc.cd_cartao_credito
where
  isnull(sa.cd_funcionario,0)>0 
  and sa.cd_solicitacao not in ( select cd_solicitacao from   #RequisicaoViagem )
  and sa.cd_solicitacao not in ( select cd_solicitacao from solicitacao_adiantamento_aprovacao )


--Solicitação de Pagamento

--Solicitação Adiantamento
--select * from solicitacao_adiantamento

select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  0                                      as cd_requisicao_viagem,
  cast(null as datetime)                 as dt_requisicao_viagem,
  0.00                                   as vl_adto_viagem,
  sa.cd_solicitacao                      as cd_solicitacao,
  sa.dt_solicitacao                      as dt_solicitacao,
  isnull(sa.vl_pagamento,0)              as vl_adiantamento,
  0                                      as cd_prestacao,
  cast(null as datetime)                 as dt_prestacao,
  0.00                                   as vl_prestacao,
  cast(null as datetime)                 as dt_fechamento_prestacao,
  cast(''   as varchar(40))              as nm_cartao_credito,
  cast('Sol.Pagamento'   as varchar(40)) as nm_status,
  0.00                                   as vl_saldo_funcionario,
  0.00                                   as vl_pagamento_funcionario,
  0.00                                   as vl_pagamento_empresa

into 
  #Pagamento
from
  Funcionario f with (nolock) 
  left outer join Solicitacao_Pagamento sa    with (nolock) on sa.cd_funcionario     = f.cd_funcionario
where
  isnull(sa.cd_funcionario,0)>0 
  and sa.cd_solicitacao not in ( select cd_solicitacao from solicitacao_pagamento_aprovacao )



--Prestação de Contas
--select * from prestacao_conta

select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  0                                  as cd_requisicao_viagem,
  cast(null as datetime)             as dt_requisicao_viagem,
  0.00                               as vl_adto_viagem,
  0                                  as cd_solicitacao,
  cast(null as datetime)             as dt_solicitacao,
  0.00                               as vl_adiantamento,
  pc.cd_prestacao                    as cd_prestacao,
  pc.dt_prestacao                    as dt_prestacao,

  pc.vl_prestacao * case when pc.vl_prestacao<0 then -1 else 1 end    

                                     as vl_prestacao,

  pc.dt_fechamento_prestacao         as dt_fechamento_prestacao,
  cc.nm_cartao_credito               as nm_cartao_credito,

  cast(case when ic_status_prestacao = 'F' 
  then
    'Fechada'
  else
    case when pc.ic_status_prestacao = 'C' then 'Contabilizada'
    else
      'Aberta' end 
  end as varchar(40))                as nm_status,

  case when ic_status_prestacao = 'C' or ic_status_prestacao = 'F' then
     0.00                          
  else
     pc.vl_prestacao * case when pc.vl_prestacao<0 then -1 else 1 end    
  end                                as vl_saldo_funcionario,

  case when pc.ic_tipo_deposito_prestacao='F' 
  then
    pc.vl_prestacao
  else
    0.00
  end                                as vl_pagamento_funcionario,

  case when pc.ic_tipo_deposito_prestacao='E'
  then
    pc.vl_prestacao * -1
  else
    0.00
  end                                as vl_pagamento_empresa

  --ic_tipo_deposito_prestacao

into 
  #PrestacaoConta
from
  Funcionario f with (nolock)
  left outer join Prestacao_Conta pc     on pc.cd_funcionario = f.cd_funcionario
  left outer join Tipo_Cartao_Credito cc on cc.cd_cartao_credito = pc.cd_cartao_credito 
where
  
  isnull(pc.cd_funcionario,0)>0 
  --Não pode mostrar as prestações que já possuem adiantamento
  and pc.cd_prestacao not in ( select cd_prestacao from #Adiantamento )
  and pc.cd_prestacao not in ( select cd_prestacao from #RequisicaoViagem )
  and pc.cd_prestacao not in ( select cd_prestacao from Prestacao_Conta_Aprovacao )


--Junta todas as Tabelas

select
  *
into
  #ExtratoFuncionario

from
  #Funcionario
union all
  select * from #RequisicaoViagem where cd_requisicao_viagem>0
union all
  select * from #Adiantamento     where cd_solicitacao>0
union all
  select * from #PrestacaoConta   where cd_prestacao>0
union all
  select * from #Pagamento        where cd_solicitacao>0


--Apresenta a Tabela Geral

  select 
    *
  from
    #ExtratoFuncionario
  where
    cd_requisicao_viagem>0 or
    cd_solicitacao>0 or
    cd_prestacao>0
  order by 
    nm_funcionario

