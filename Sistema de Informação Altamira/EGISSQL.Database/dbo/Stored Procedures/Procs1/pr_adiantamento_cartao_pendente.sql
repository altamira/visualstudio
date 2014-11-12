
-------------------------------------------------------------------------------
--sp_helptext pr_adiantamento_cartao_pendente
-------------------------------------------------------------------------------
--pr_adiantamento_cartao_pendente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta de Adiantamento de Cartão Pendente
--Data             : 07.12.2010
--Alteração        : 
--
-- 13.12.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_adiantamento_cartao_pendente
@dt_inicial        datetime,
@dt_final          datetime,
@cd_cartao_credito int       = 0,
@cd_funcionario    int       = 0,
@cd_departamento   int       = 0,
@cd_centro_custo   int       = 0

as

--select * from solicitacao_adiantamento
  
select
  sa.cd_solicitacao                                                       as 'SA',
  case when sc.dt_contab_adiantamento is null then
    sa.dt_solicitacao                
  else
    sc.dt_contab_adiantamento
  end                                                                     as 'Data',

  cast('' as varchar(15))                                                 as 'Documento',
  cast(f.cd_chapa_funcionario as varchar(10))                             as 'Dimensao',
  f.nm_funcionario                                                        as 'Funcionario',
  cc.nm_centro_custo                                                      as 'CentroCusto',
  d.nm_departamento                                                       as 'Departamento',
  case when sc.nm_historico_contabil is null then
     ltrim(ltrim(cast(sa.cd_solicitacao as varchar))) + '-'+f.nm_funcionario
  else
    sc.nm_historico_contabil
  end                                                                     as 'Historico',
 
  tcc.nm_cartao_credito                                                   as 'Cartao',
  m.sg_moeda                                                              as 'Moeda',
  sa.vl_solicitacao_moeda                                                 as 'Valor_Origem',
  sa.vl_adiantamento                                                      as 'Valor_Adiantamento' --> Valor em R$

from
  --select * from solicitacao_adiantamento_contabil

  solicitacao_adiantamento sa             with (nolock) 
  left outer join centro_custo cc         with (nolock) on cc.cd_centro_custo    = sa.cd_centro_custo
  left outer join departamento d          with (nolock) on d.cd_departamento     = sa.cd_departamento
  left outer join funcionario  f          with (nolock) on f.cd_funcionario      = sa.cd_funcionario
  left outer join tipo_cartao_credito tcc with (nolock) on tcc.cd_cartao_credito = sa.cd_cartao_credito
  left outer join moeda m                 with (nolock) on m.cd_moeda            = sa.cd_moeda
  left outer join solicitacao_adiantamento_contabil sc  on sc.cd_solicitacao     = sa.cd_solicitacao
  
--select * from tipo_cartao_credito
--select * from centro_custo
--select * from funcionario

where
  sa.dt_solicitacao between @dt_inicial and @dt_final and
  sa.cd_funcionario    = case when @cd_funcionario    = 0 then sa.cd_funcionario    else @cd_funcionario    end and
  sa.cd_cartao_credito = case when @cd_cartao_credito = 0 then sa.cd_cartao_credito else @cd_cartao_credito end and
  sa.cd_centro_custo   = case when @cd_centro_custo   = 0 then sa.cd_centro_custo   else @cd_centro_custo   end and
  sa.cd_departamento   = case when @cd_departamento   = 0 then sa.cd_departamento   else @cd_departamento   end and
  isnull(sa.cd_prestacao,0)=0        and
  isnull(sa.cd_cartao_credito,0)<>0  --Cartão Crédito

 order by
  sa.dt_solicitacao,
  f.nm_funcionario

