
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_extrato_funcionario
-------------------------------------------------------------------------------
--pr_consulta_extrato_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Toda a Movimentação do Funcionário
--                   Módulo de Viagens
--                   Requisição de Viagem
--                   Solicitação Adiantamento / Prestação de Contas 
--                   Solicitação de Pagamento
--Data             : 01/05/2007
--Alteração        : 19.11.2007 - Acertos Diversos - Carlos Fernandes
--10.12.2007 - Consulta de Extrato por Funcionário Individual
--           - Grupo de Funcionários conforme Secretárias
--20.12.2007 - Acerto no Filtro da Secretária - Carlos Fernandes
--26.12.2007 - Acerto no Filtro por Período e Usuário Supervidor - Carlos Fernandes
--28.12.2007 - Filtro por Grupo de Usuário - Carlos Fernandes
--14.01.2008 - Data Mais Antiga - Carlos Fernandes
--18.01.2008 - Acerto do Valor do Adiantamento para Moeda Estrangeira - Carlos Fernandes
--25.01.2008 - Acerto do Valor da Prestação de Contas = Total despesas - Carlos Fernandes
--06.03.2009 - Ajustes Diversos - Carlos Fernandes
-------------------------------------------------------------------------------------------
create procedure pr_consulta_extrato_funcionario
@ic_parametro   int      = 0,
@cd_funcionario int      = 0,
@dt_inicial     datetime = '',
@dt_final       datetime = '', 
@cd_usuario     int      = 0

as

--Verifica do Tipo de Usuário

declare @ic_supervisor    char(1)
declare @cd_grupo_usuario int
declare @ic_extrato       char(1)

select
   @ic_supervisor = isnull(ic_tipo_usuario,'N')
from
   egisadmin.dbo.usuario with (nolock) 
where
  cd_usuario = @cd_usuario

--Busca o Grupo do Usuário

SELECT top 1
  @cd_grupo_usuario = isnull(GU.cd_grupo_usuario,0),
  @ic_extrato       = isnull(gu.ic_extrato_funcionario,'N')
FROM 
  egisadmin.dbo.Usuario_GrupoUsuario UGU   with (nolock) 
  inner join egisadmin.dbo.GrupoUsuario GU with (nolock) on GU.cd_grupo_usuario = UGU.cd_grupo_usuario  
WHERE 
  UGU.cd_usuario   = @cd_usuario  and
  isnull(gu.ic_extrato_funcionario,'N')='S' 
ORDER BY 
  GU.nm_grupo_usuario  

--Tabela Temporária para consulta das Solicitações para os usuários do mesmo Grupo

SELECT 
  isnull(u.cd_usuario,0) as cd_usuario
into
  #GrupoUsuario
FROM 
  egisadmin.dbo.Usuario u with (nolock) 
  INNER JOIN
  egisadmin.dbo.Usuario_GrupoUsuario ug ON u.cd_usuario = ug.cd_usuario
WHERE
  ug.cd_grupo_usuario = @cd_grupo_usuario

--Verifica se o Usuário é Supervisor

if @ic_supervisor = 'S'
begin
  set @cd_usuario     = 0
  set @cd_funcionario = 0
end

--Verifica se o Grupo pode consultar o Extrato

if @ic_extrato = 'S'
begin
  set @cd_usuario     = 0
  set @cd_funcionario = 0
end

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
  0.00                               as vl_pagamento_empresa,
  0.00                               as vl_despesa_prestacao

into 
  #Funcionario
from
  Funcionario f with (nolock)
where
  isnull(f.cd_funcionario,0)>0 and
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end


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
  isnull(rv.vl_adto_viagem,0)         as vl_adto_viagem,
  sa.cd_solicitacao                   as cd_solicitacao,
  sa.dt_solicitacao                   as dt_solicitacao,
  case when isnull(sa.vl_total_moeda_solicitacao,0)>0
  then
   isnull(sa.vl_total_moeda_solicitacao,0)
  else
   isnull(sa.vl_adiantamento,0)
  end                                 as vl_adiantamento,
  isnull(sa.cd_prestacao,0)           as cd_prestacao,
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
  end                                as vl_pagamento_empresa,
  isnull(pc.vl_despesa_prestacao,0)  as vl_despesa_prestacao

into
  #RequisicaoViagem
from
  Funcionario f                               with (nolock)
  left outer join Requisicao_Viagem rv        with (nolock) on rv.cd_funcionario       = f.cd_funcionario
  left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_requisicao_viagem = rv.cd_requisicao_viagem
  left outer join Prestacao_Conta pc          with (nolock) on pc.cd_prestacao         = sa.cd_prestacao
  left outer join Tipo_Cartao_Credito tcc     with (nolock) on tcc.cd_cartao_credito   = pc.cd_cartao_credito

where
  isnull(rv.cd_requisicao_viagem,0)>0 and
  isnull(rv.cd_funcionario,0)>0       and
  rv.cd_funcionario = case when @cd_funcionario = 0 then rv.cd_funcionario else @cd_funcionario end and
  rv.dt_requisicao_viagem between @dt_inicial and @dt_final


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
  case when isnull(sa.vl_total_moeda_solicitacao,0)>0
  then
   isnull(sa.vl_total_moeda_solicitacao,0)
  else
   isnull(sa.vl_adiantamento,0)
  end                                 as vl_adiantamento,
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
  end                                as vl_pagamento_empresa,
  isnull(pc.vl_despesa_prestacao,0)  as vl_despesa_prestacao

into 
  #Adiantamento
from
  Funcionario f                               with (nolock) 
  left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_funcionario     = f.cd_funcionario
  left outer join Prestacao_Conta pc          with (nolock) on pc.cd_prestacao       = sa.cd_prestacao
  left outer join Tipo_Cartao_Credito tcc     with (nolock) on tcc.cd_cartao_credito = pc.cd_cartao_credito
where
  isnull(sa.cd_funcionario,0)>0 and
  sa.cd_funcionario = case when @cd_funcionario = 0 then sa.cd_funcionario else @cd_funcionario end
  and sa.cd_solicitacao not in ( select cd_solicitacao from   #RequisicaoViagem )
  and sa.dt_solicitacao between @dt_inicial and @dt_final


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
    isnull(pc.vl_prestacao,0)
  else
    0.00
  end                                as vl_pagamento_funcionario,

  case when pc.ic_tipo_deposito_prestacao='E'
  then
    isnull(pc.vl_prestacao,0) * -1
  else
    0.00
  end                                as vl_pagamento_empresa,
  isnull(pc.vl_despesa_prestacao,0)  as vl_despesa_prestacao


  --ic_tipo_deposito_prestacao

into 
  #PrestacaoConta
from
  Funcionario f                          with (nolock)
  left outer join Prestacao_Conta pc     with (nolock) on pc.cd_funcionario    = f.cd_funcionario
  left outer join Tipo_Cartao_Credito cc with (nolock) on cc.cd_cartao_credito = pc.cd_cartao_credito 
where
  isnull(pc.cd_funcionario,0)>0 and
  pc.cd_funcionario = case when @cd_funcionario = 0 then pc.cd_funcionario else @cd_funcionario end
  --Não pode mostrar as prestações que já possuem adiantamento
  and pc.cd_prestacao not in ( select cd_prestacao from #Adiantamento )
  and pc.cd_prestacao not in ( select cd_prestacao from #RequisicaoViagem )
  and pc.dt_prestacao between @dt_inicial and @dt_final

--Atualização do Saldo do Funcionário


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


--Verifica se o Usuário é Secretária---------------------------------------------------------

if @cd_usuario>0 
begin

  declare @cd_funcionario_secretaria int

  select
    @cd_funcionario_secretaria = isnull(cd_funcionario,0)
  from
    egisadmin.dbo.usuario with (nolock) 
  where
    cd_usuario = @cd_usuario
   
  --select * from secretaria

  select
    isnull(cd_funcionario,0) as cd_funcionario
  into
    #FuncionarioSecretaria 
  from
    Secretaria with (nolock) 
  where
    cd_usuario_sistema = @cd_usuario

  if @cd_funcionario_secretaria>0
  begin
    insert into
      #FuncionarioSecretaria
    select
      @cd_funcionario_secretaria
  end

  --delete os funcinários que não são do grupo de secretárias

  if exists( select top 1 cd_funcionario from #FuncionarioSecretaria )
  begin
    delete from #ExtratoFuncionario where cd_funcionario not in ( select cd_funcionario from #FuncionarioSecretaria )
  end


end

--Apresenta a Tabela Geral

if @ic_parametro = 0 or @ic_parametro = 2
begin
  select 
    *
  from
    #ExtratoFuncionario
  where
    cd_requisicao_viagem>0 or
    cd_solicitacao>0 or
    cd_prestacao>0
  end

--Mostra os Funcionários com Saldo de Adiantamento
--Resumo

if @ic_parametro = 1
begin
  select 
    e.cd_funcionario,
    e.nm_funcionario,
    sum(isnull( e.vl_saldo_funcionario,0)) as vl_saldo_funcionario,
    max(d.nm_departamento)                 as nm_departamento,
    max(cc.nm_centro_custo)                as nm_centro_custo,
    max(e.cd_chapa_funcionario)            as cd_chapa_funcionario,
    min(e.dt_solicitacao)                  as dt_solicitacao,
    count(e.cd_solicitacao)                as qtd_solicitacao

    --max(cd_chapa_funcionario)            as cd_chapa_funcionario
--  into
--    #ExtratoSaldo
  from
    #ExtratoFuncionario e
    left outer join Funcionario f   on f.cd_funcionario    = e.cd_funcionario
    left outer join Departamento d  on d.cd_departamento   = f.cd_departamento
    left outer join Centro_Custo cc on cc.cd_centro_custo  = f.cd_centro_custo
  where
    e.vl_saldo_funcionario > 0 and
    (
    e.cd_requisicao_viagem>0 or
    e.cd_solicitacao>0 or
    e.cd_prestacao>0 )
  group by
    e.cd_funcionario,
    e.nm_funcionario
  order by
    e.nm_funcionario
   
--   select 
--     *
--   from 
--     #ExtratoSaldo
--   order by
--     nm_funcionario

end

-- order by
--   dt_requisicao_viagem,
--   dt_solicitacao,
--   dt_prestacao
-- 

--requisicao de viagem
--select * from requisicao_viagem
--select * from solicitacao_adiantamento

