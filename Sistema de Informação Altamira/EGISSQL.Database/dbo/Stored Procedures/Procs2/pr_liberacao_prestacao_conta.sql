
-------------------------------------------------------------------------------
--sp_helptext pr_liberacao_prestacao_conta
-------------------------------------------------------------------------------
--pr_liberacao_prestacao_conta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Liberação de Prestação de Contas
--Data             : 12.11.2007
--Alteração        : 14.11.2007 separação do cartão de crédito
-- 26.12.2007 - Acerto do Valor da Prestação
-- 20.06.2008 
------------------------------------------------------------------------------
create procedure pr_liberacao_prestacao_conta
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@ic_selecao   int      = 0
as

--select * from prestacao_conta

--todas

if @ic_parametro = 0
begin

  Select
    @ic_selecao                        as Sel,
    pc.*,
    tpc.nm_tipo_prestacao,
    f.nm_funcionario,
    d.nm_departamento,
    c.nm_centro_custo,
    tcc.nm_cartao_credito
  from
    Prestacao_Conta pc                      with (nolock)
    left join Tipo_Prestacao_Conta tpc      with (nolock) On pc.cd_tipo_prestacao  = tpc.cd_tipo_prestacao 
    left join Funcionario F                 with (nolock) On f.cd_funcionario      = pc.cd_funcionario
    left join Departamento D                with (nolock) On d.cd_departamento     = pc.cd_departamento
    left join Centro_Custo C                with (nolock) On c.cd_centro_custo     = pc.cd_centro_custo
    left outer join Tipo_Cartao_Credito tcc with (nolock) on tcc.cd_cartao_credito = pc.cd_cartao_credito

  where
--    isnull(pc.cd_cartao_credito,0) = 0 and
    pc.dt_fechamento_prestacao     is not null and
    pc.dt_liberacao_prestacao      is null
  order by
    pc.dt_prestacao
  
end

------------------------------------------------------------------------------
--Sem Cartão de Crédito
------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  Select
    @ic_selecao                        as Sel,
    pc.*,
    tpc.nm_tipo_prestacao,
    f.nm_funcionario,
    d.nm_departamento,
    c.nm_centro_custo,
    tcc.nm_cartao_credito
  from
    Prestacao_Conta pc                      with (nolock)
    left join Tipo_Prestacao_Conta tpc      with (nolock) On pc.cd_tipo_prestacao  = tpc.cd_tipo_prestacao 
    left join Funcionario F                 with (nolock) On f.cd_funcionario      = pc.cd_funcionario
    left join Departamento D                with (nolock) On d.cd_departamento     = pc.cd_departamento
    left join Centro_Custo C                with (nolock) On c.cd_centro_custo     = pc.cd_centro_custo
    left outer join Tipo_Cartao_Credito tcc with (nolock) on tcc.cd_cartao_credito = pc.cd_cartao_credito

  where
    isnull(pc.cd_cartao_credito,0) = 0 and
    pc.dt_fechamento_prestacao     is not null and
    pc.dt_liberacao_prestacao      is null
  order by
    pc.dt_prestacao
  
end

--Cartão de Crédito

if @ic_parametro = 2
begin

  Select
    @ic_selecao                        as Sel,
    pc.*,
    tpc.nm_tipo_prestacao,
    f.nm_funcionario,
    d.nm_departamento,
    c.nm_centro_custo,
    tcc.nm_cartao_credito
  from
    Prestacao_Conta pc                      with (nolock)
    left join Tipo_Prestacao_Conta tpc      with (nolock) On pc.cd_tipo_prestacao  = tpc.cd_tipo_prestacao 
    left join Funcionario F                 with (nolock) On f.cd_funcionario      = pc.cd_funcionario
    left join Departamento D                with (nolock) On d.cd_departamento     = pc.cd_departamento
    left join Centro_Custo C                with (nolock) On c.cd_centro_custo     = pc.cd_centro_custo
    left outer join Tipo_Cartao_Credito tcc with (nolock) on tcc.cd_cartao_credito = pc.cd_cartao_credito

  where
    isnull(pc.cd_cartao_credito,0) > 0 and
    pc.dt_fechamento_prestacao     is not null and
    pc.dt_liberacao_prestacao      is null
  order by
    pc.dt_prestacao
  
end


