
-------------------------------------------------------------------------------
--sp_helptext pr_deposito_adiantamento_funcionario
-------------------------------------------------------------------------------
--pr_deposito_adiantamento_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : Egissql
--Objetivo         : Consula de Depósitos para Funcionário
--Data             : 09/05/2007
--Alteração        : 31.08.2007 - Ordem de Apresentação
--                 : 24.09.2007 - Matrícula - Carlos Fernandes
--                 : 28.09.2007 - Filtro por Moeda - Somente R$ - Carlos Fernandes
--                 : 22.10.2007 - Acerto da Impressão apenas o que é Depósito - Carlos Fernandes
--                 : 05.11.2007 - Verificação do Atributo p/ não mostrar adto liberado - Carlos 
-- 14.11.2007 - Colocar somente os Adiantamentos - Carlos Fernandes
-- 26.11.2007 - Consistência da Aprovação - Carlos Fernandes
-- 30.11.2007 - Liberação do Financeiro - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_deposito_adiantamento_funcionario
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_moeda   int      = 0

as

--select * from solicitacao_adiantamento

  select 
    sa.cd_solicitacao,
    sa.dt_solicitacao,
    isnull(case
      when isnull(sa.vl_adiantamento,0) < 0 then
        isnull(sa.vl_adiantamento,0) *(-1)
      else
        isnull(sa.vl_adiantamento,0)
    end,0)                                    as vl_adiantamento,
    f.nm_funcionario,
    case
      when isnull(ta.ic_dinheiro_tipo_adiantamento,'N') = 'S' then
        ''
      else
        isnull(b.nm_banco,'')                     
    end                                       as nm_banco,
    case
      when isnull(ta.ic_dinheiro_tipo_adiantamento,'N') = 'S' then
        ''
      else
        isnull(f.cd_agencia_funcionario,'')       
    end                                       as cd_agencia_funcionario,
    case
      when isnull(ta.ic_dinheiro_tipo_adiantamento,'N') = 'S' then
        ''
      else
        isnull(f.cd_conta_funcionario,'')         
    end                                       as cd_conta_funcionario,
    isnull(d.nm_departamento,'')              as nm_departamento,
    isnull(cc.nm_centro_custo,'')             as nm_centro_custo,
    case
      when isnull(ta.ic_dinheiro_tipo_adiantamento,'N') = 'N' then
        'Depósito'
      else
        'Dinheiro'
    end as ic_tipo_Adiantamento,
    f.cd_chapa_funcionario,
    f.nm_setor_funcionario,
    m.sg_moeda,
    'SA'                                     as ic_tipo
  into
    #SolicitacaoAdiantamento
  from
    Solicitacao_Adiantamento sa                       with (nolock)
    left join Funcionario f                           with (nolock) on f.cd_funcionario        = sa.cd_funcionario  
    left join Departamento d                          with (nolock) on d.cd_departamento       = sa.cd_departamento
    left join Centro_Custo cc                         with (nolock) on cc.cd_centro_custo      = sa.cd_centro_custo
    left join Banco b                                 with (nolock) on b.cd_banco              = f.cd_banco 
    left join Tipo_Adiantamento ta                    with (nolock) on ta.cd_tipo_adiantamento = sa.cd_tipo_adiantamento
    left join Moeda m                                 with (nolock) on m.cd_moeda              = sa.cd_moeda
    inner join Solicitacao_Adiantamento_Aprovacao saa with (nolock) on saa.cd_solicitacao = sa.cd_solicitacao
  where
    sa.cd_moeda = case when @cd_moeda = 0 then sa.cd_moeda else @cd_moeda end and
    sa.dt_solicitacao between @dt_inicial and @dt_final   and
    isnull(ta.ic_deposito_adiantamento,'N')='S'           and
    sa.dt_conf_solicitacao is null                        and
    isnull(saa.ic_aprovado,'N')='S'                       and
    dt_financeiro_solicitacao is not null
      

    --isnull(sa.ic_tipo_adiantamento,'1') = '2' --depósito  
    --isnull(ta.ic_dinheiro_tipo_adiantamento,'N') = 'N'
    --select * from tipo_adiantamento

  order by
    sa.dt_solicitacao desc, 
    sa.cd_solicitacao desc


--Depósitos com a Prestação de Contas
  --select * from prestacao_conta

--   select 
--     pc.cd_prestacao                          as cd_solicitacao,
--     pc.dt_prestacao                          as dt_solicitacao,
--     isnull(case
--       when pc.vl_prestacao < 0 then
--         pc.vl_prestacao *(-1)
--       else
--         pc.vl_prestacao
--     end,0)                                    as vl_adiantamento,
--     f.nm_funcionario,
--     case
--       when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
--         ''
--       else
--         isnull(b.nm_banco,'')                     
--     end                                       as nm_banco,
--     case
--       when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
--         ''
--       else
--         isnull(f.cd_agencia_funcionario,'')       
--     end                                       as cd_agencia_funcionario,
--     case
--       when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
--         ''
--       else
--         isnull(f.cd_conta_funcionario,'')         
--     end                                       as cd_conta_funcionario,
--     isnull(d.nm_departamento,'')              as nm_departamento,
--     isnull(cc.nm_centro_custo,'')             as nm_centro_custo,
--     case
--       when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
--         'Empresa'
--       else
--         'Funcionário'
--     end                                       as ic_tipo_Adiantamento,
-- 
--     f.cd_chapa_funcionario,
--     f.nm_setor_funcionario,
--     m.sg_moeda,
--     'PC'                                     as ic_tipo
-- 
--   into
--     #PrestacaoConta
--   from
--     Prestacao_Conta pc        with (nolock)
--     left join Funcionario f   with (nolock) on f.cd_funcionario   = pc.cd_funcionario  
--     left join Departamento d  with (nolock) on d.cd_departamento  = pc.cd_departamento
--     left join Centro_Custo cc with (nolock) on cc.cd_centro_custo = pc.cd_centro_custo
--     left join Banco b         with (nolock) on b.cd_banco = f.cd_banco 
--     left join Moeda m         with (nolock) on m.cd_moeda = isnull(pc.cd_moeda,1)
--   where
--     pc.dt_prestacao between @dt_inicial and @dt_final and
--     isnull(pc.cd_cartao_credito,0) = 0                and
--     pc.dt_conf_prestacao is null                      and
--     pc.ic_status_prestacao = 'F'                      and
--     pc.ic_tipo_deposito_prestacao = 'F'               --depósito para o Funcionário
-- 
-- --select * from prestacao_conta
-- 
--   order by
--     isnull(pc.ic_tipo_deposito_prestacao,'E') Desc,
--     pc.dt_prestacao      

--select * from #PrestacaoConta


--Mostra a Tabela Final


select * from #SolicitacaoAdiantamento
order by
   dt_solicitacao desc, 
   cd_solicitacao desc

-- union all
--   select * from #PrestacaoConta

--select * from solicitacao_adiantamento
--select * from tipo_adiantamento
--select * from prestacao_conta

