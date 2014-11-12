
-------------------------------------------------------------------------------
--sp_helptext pr_migracao_altamira_plano_contas
-------------------------------------------------------------------------------
--pr_migracao_altamira_plano_contas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração de Plano de Contas
--Data             : 01.06.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_plano_contas
as

--select * from migracao.dbo.ativo$
--select * from migracao.dbo.passivo
--select * from egisadmin.dbo.usuario
--select * from plano_conta

delete from plano_conta

--select * from historico_contabil

select
  1                 as cd_empresa,
  identity(int,1,1) as cd_conta,
  [conta]           as cd_mascara_conta,
  [descrição]       as nm_conta,

  'D'               as ic_tipo_conta,

  case when [reduzida] is not null then
    'a'
  else
    'T'
  end               as ic_conta_analitica,

  case when [reduzida] is null then
    'S'
  else
    'N'
  end               as ic_conta_balanco,
  'N'               as ic_conta_resultado,
  'N'               as ic_conta_custo,
  'N'               as ic_conta_analise,
  'L'               as ic_situacao_conta,
  case when [reduzida]  is not null then
    'S'
  else
    'N'
  end               as ic_lancamento_conta,
  0.00              as vl_saldo_inicial_conta,
  null              as ic_saldo_inicial_conta,
  0.00              as vl_debito_conta,
  0.00              as vl_credito_conta,
  0                 as qt_lancamento_conta,
  0.00              as vl_saldo_atual_conta,
  null              as ic_saldo_atual_conta,
  1                 as cd_grupo_conta,
  case when [reduzida] is not null then
   cast( [reduzida] as int )
  else
   0
  end                     as cd_conta_reduzido,
23 as cd_usuario,
getdate() as dt_usuario,
 dbo.fn_grau_conta_contabil([Conta]) as qt_grau_conta,
    null as cd_conta_sintetica,
  null as ic_conta_demonstrativo,
  null as cd_centro_custo,
  null as cd_centro_receita,
  null as nm_obs_plano_conta

into
 #plano_conta_a
from
 migracao.dbo.[ativo$] 

--Passivo

select
  1                 as cd_empresa,
  0 as cd_conta,
  [Conta]              as cd_mascara_conta,
  [Descrição]              as nm_conta,

  'D'               as ic_tipo_conta,

  case when [reduzida] is not null then
    'a'
  else
    'T'
  end               as ic_conta_analitica,

  case when [reduzida] is null then
    'S'
  else
    'N'
  end               as ic_conta_balanco,
  'N'               as ic_conta_resultado,
  'N'               as ic_conta_custo,
  'N'               as ic_conta_analise,
  'L'               as ic_situacao_conta,
  case when [reduzida]  is not null then
    'S'
  else
    'N'
  end               as ic_lancamento_conta,
  0.00              as vl_saldo_inicial_conta,
  null              as ic_saldo_inicial_conta,
  0.00              as vl_debito_conta,
  0.00              as vl_credito_conta,
  0                 as qt_lancamento_conta,
  0.00              as vl_saldo_atual_conta,
  null              as ic_saldo_atual_conta,
  2                 as cd_grupo_conta,
  case when [reduzida] is not null then
   cast( [reduzida] as int )
  else
   0
  end                     as cd_conta_reduzido,
23 as cd_usuario,
getdate() as dt_usuario,
 dbo.fn_grau_conta_contabil([Conta]) as qt_grau_conta,
  --  null as cd_conta_sintetica,
  identity(int,1,1) as cd_conta_sintetica,
  null as ic_conta_demonstrativo,
  null as cd_centro_custo,
  null as cd_centro_receita,
  null as nm_obs_plano_conta

into
 #plano_conta_p
from
 migracao.dbo.[passivo$] 


--Despesa

select
  1                 as cd_empresa,
  0 as cd_conta,
  [Conta]              as cd_mascara_conta,
  [Descrição]              as nm_conta,

  'D'               as ic_tipo_conta,

  case when [reduzida] is not null then
    'a'
  else
    'T'
  end               as ic_conta_analitica,

  case when [reduzida] is null then
    'S'
  else
    'N'
  end               as ic_conta_balanco,
  'N'               as ic_conta_resultado,
  'N'               as ic_conta_custo,
  'N'               as ic_conta_analise,
  'L'               as ic_situacao_conta,
  case when [reduzida]  is not null then
    'S'
  else
    'N'
  end               as ic_lancamento_conta,
  0.00              as vl_saldo_inicial_conta,
  null              as ic_saldo_inicial_conta,
  0.00              as vl_debito_conta,
  0.00              as vl_credito_conta,
  0                 as qt_lancamento_conta,
  0.00              as vl_saldo_atual_conta,
  null              as ic_saldo_atual_conta,
  4                 as cd_grupo_conta,
  case when [reduzida] is not null then
   cast( [reduzida] as int )
  else
   0
  end                     as cd_conta_reduzido,
23 as cd_usuario,
getdate() as dt_usuario,
 dbo.fn_grau_conta_contabil([Conta]) as qt_grau_conta,
  --  null as cd_conta_sintetica,
  identity(int,1,1) as cd_conta_sintetica,
  null as ic_conta_demonstrativo,
  null as cd_centro_custo,
  null as cd_centro_receita,
  null as nm_obs_plano_conta

into
 #plano_conta_d
from
 migracao.dbo.[despesa$] 


--Receita

select
  1                 as cd_empresa,
  0 as cd_conta,
  [Conta]              as cd_mascara_conta,
  [Descrição]              as nm_conta,

  'D'               as ic_tipo_conta,

  case when [reduzida] is not null then
    'a'
  else
    'T'
  end               as ic_conta_analitica,

  case when [reduzida] is null then
    'S'
  else
    'N'
  end               as ic_conta_balanco,
  'N'               as ic_conta_resultado,
  'N'               as ic_conta_custo,
  'N'               as ic_conta_analise,
  'L'               as ic_situacao_conta,
  case when [reduzida]  is not null then
    'S'
  else
    'N'
  end               as ic_lancamento_conta,
  0.00              as vl_saldo_inicial_conta,
  null              as ic_saldo_inicial_conta,
  0.00              as vl_debito_conta,
  0.00              as vl_credito_conta,
  0                 as qt_lancamento_conta,
  0.00              as vl_saldo_atual_conta,
  null              as ic_saldo_atual_conta,
  3                 as cd_grupo_conta,
  case when [reduzida] is not null then
   cast( [reduzida] as int )
  else
   0
  end                     as cd_conta_reduzido,
23 as cd_usuario,
getdate() as dt_usuario,
 dbo.fn_grau_conta_contabil([Conta]) as qt_grau_conta,
  --  null as cd_conta_sintetica,
  identity(int,1,1) as cd_conta_sintetica,
  null as ic_conta_demonstrativo,
  null as cd_centro_custo,
  null as cd_centro_receita,
  null as nm_obs_plano_conta

into
 #plano_conta_r
from
 migracao.dbo.[receita$] 

--Resultado

select
  1                 as cd_empresa,
  0 as cd_conta,
  [Conta]              as cd_mascara_conta,
  [Descrição]              as nm_conta,

  'D'               as ic_tipo_conta,

  case when [reduzida] is not null then
    'a'
  else
    'T'
  end               as ic_conta_analitica,

  case when [reduzida] is null then
    'S'
  else
    'N'
  end               as ic_conta_balanco,
  'N'               as ic_conta_resultado,
  'N'               as ic_conta_custo,
  'N'               as ic_conta_analise,
  'L'               as ic_situacao_conta,
  case when [reduzida]  is not null then
    'S'
  else
    'N'
  end               as ic_lancamento_conta,
  0.00              as vl_saldo_inicial_conta,
  null              as ic_saldo_inicial_conta,
  0.00              as vl_debito_conta,
  0.00              as vl_credito_conta,
  0                 as qt_lancamento_conta,
  0.00              as vl_saldo_atual_conta,
  null              as ic_saldo_atual_conta,
  6                 as cd_grupo_conta,
  case when [reduzida] is not null then
   cast( [reduzida] as int )
  else
   0
  end                     as cd_conta_reduzido,
23 as cd_usuario,
getdate() as dt_usuario,
 dbo.fn_grau_conta_contabil([Conta]) as qt_grau_conta,
  --  null as cd_conta_sintetica,
  identity(int,1,1) as cd_conta_sintetica,
  null as ic_conta_demonstrativo,
  null as cd_centro_custo,
  null as cd_centro_receita,
  null as nm_obs_plano_conta

into
 #plano_conta_s
from
 migracao.dbo.[resultado$] 

--select * from grupo_conta

insert into
 plano_conta
select
 *
from
 #plano_conta_a

declare @cd_conta int

select 
  @cd_conta = isnull( max(cd_conta),0) + 1
from
  plano_conta

update
  #plano_conta_p
set
  cd_conta = @cd_conta + cd_conta_sintetica

insert into
 plano_conta
select
 *
from
 #plano_conta_p

--despesa

select 
  @cd_conta = isnull( max(cd_conta),0) + 1
from
  plano_conta

update
  #plano_conta_d
set
  cd_conta = @cd_conta + cd_conta_sintetica

insert into
 plano_conta
select
 *
from
 #plano_conta_d

--receita

select 
  @cd_conta = isnull( max(cd_conta),0) + 1
from
  plano_conta

update
  #plano_conta_r
set
  cd_conta = @cd_conta + cd_conta_sintetica

insert into
 plano_conta
select
 *
from
 #plano_conta_r

--Resultado

select 
  @cd_conta = isnull( max(cd_conta),0) + 1
from
  plano_conta

update
  #plano_conta_s
set
  cd_conta = @cd_conta + cd_conta_sintetica

insert into
 plano_conta
select
 *
from
 #plano_conta_s


select * from plano_conta

drop table #plano_conta_a
drop table #plano_conta_p

