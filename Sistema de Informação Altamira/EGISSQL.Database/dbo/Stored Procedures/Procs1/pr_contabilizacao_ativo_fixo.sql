
--sp_helptext pr_contabilizacao_ativo_fixo
-------------------------------------------------------------------------------
--pr_contabilizacao_ativo_fixo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Contabilização do Ativo Fixo
--Data             : 22.01.2007
--Alteração        : 28.04.2007 - Acertos Gerais
--                 : 30.04.2007 - Colocando parametro para mostar por centro de
--                   custo ou por contas - Anderson.
-------------------------------------------------------------------------------
create procedure pr_contabilizacao_ativo_fixo
@ic_parametro    int = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int = 0

as

--select * from ativo_contabilizacao
--select * from plano_conta

select
  a.cd_ativo_contabilizacao,
  a.dt_ativo_contabilizacao,
  a.cd_lancamento_padrao,

  --Débito

  a.cd_conta_debito,
  d.nm_conta                       as Descricao_ContaDebito,
  d.cd_mascara_conta               as ContaDebito,
  d.cd_conta_reduzido              as Reduzido_ContaDebito,

  --Crédito

  a.cd_conta_credito,
  c.nm_conta                       as Descricao_ContaCredito,
  c.cd_mascara_conta               as ContaCredito,
  c.cd_conta_reduzido              as Reduzido_ContaCredito,

  a.cd_historico_contabil,
  a.nm_historico_ativo,
  a.nm_complemento_ativo,
  a.vl_ativo_contabilizacao,
  a.cd_centro_custo,
  cc.cd_mascara_centro_custo,
  cc.nm_centro_custo

into
  #AtivoContabilizacao
from
  Ativo_Contabilizacao a
  left outer join plano_conta d   on d.cd_conta        = a.cd_conta_debito
  left outer join plano_conta c   on c.cd_conta        = a.cd_conta_credito
  left outer join Centro_Custo cc on c.cd_centro_custo = a.cd_centro_custo

where
  a.dt_ativo_contabilizacao between @dt_inicial and @dt_final and
  isnull(a.cd_centro_custo,0) = case when isnull(@cd_centro_custo,0) = 0 then isnull(a.cd_centro_custo,0) else @cd_centro_custo end

order by
  a.dt_ativo_contabilizacao

if @ic_parametro = 1
begin
  select * from #AtivoContabilizacao order by nm_centro_custo, ContaDebito, ContaCredito
end
else
begin
  select 
    --cd_ativo_contabilizacao,
    --dt_ativo_contabilizacao,
    --cd_lancamento_padrao,

    --Débito
 
    cd_conta_debito,
    Descricao_ContaDebito,
    ContaDebito,
    Reduzido_ContaDebito,

    --Crédito

    cd_conta_credito,
    Descricao_ContaCredito,
    ContaCredito,
    Reduzido_ContaCredito,

    cd_historico_contabil,
    nm_historico_ativo,
    nm_complemento_ativo,
    SUM(vl_ativo_contabilizacao) as vl_ativo_contabilizacao
  from 
    #AtivoContabilizacao
  group by
    cd_conta_debito,
    Descricao_ContaDebito,
    ContaDebito,
    Reduzido_ContaDebito,

    --Crédito

    cd_conta_credito,
    Descricao_ContaCredito,
    ContaCredito,
    Reduzido_ContaCredito,

    cd_historico_contabil,
    nm_historico_ativo,
    nm_complemento_ativo
  order by
    ContaDebito, 
    ContaCredito
    
end

