
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_adiantamento_prestacao
-------------------------------------------------------------------------------
--pr_consulta_adiantamento_prestacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta para Mostrar todos os Adiantamentos em Aberto
--Data             : 01/05/2007
--Alteração        : 27.09.2007 - Mostrar os Adiantamentos também sem RV - Carlos Fernandes
--                 : 02.10.2007 - Mostrar o Tipo de Adiantamento
-- 11.01.2008 - Acerto da Consulta - Carlos Fernandes
-- 25.04.2008 - Ajuste para nova regra de cartão de crédito - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_adiantamento_prestacao
@cd_funcionario    int      = 0,
@ic_selecionado    int      = 0, 
@cd_cartao_credito int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = ''

as

--select * from solicitacao_adiantamento

select
  @ic_selecionado                            as ic_selecao,
  sa.dt_vencimento                           as Vencimento,
  cast(getdate() - sa.dt_vencimento as int ) as Dias,
  sa.cd_solicitacao                          as Numero,
  sa.dt_solicitacao                          as Emissao,
  sa.vl_adiantamento                         as Valor,
  sa.vl_saldo_adiantamento                   as Saldo,
  mo.sg_moeda                                as Moeda,
  sa.cd_requisicao_viagem                    as Requisicao,
  fa.nm_finalidade_adiantamento              as Finalidade,
  f.nm_funcionario                           as Funcionario,
  ta.nm_tipo_adiantamento                    as TipoAdiantamento  
from
  solicitacao_adiantamento sa                with (nolock) 
  left outer join funcionario             f  with (nolock) on f.cd_funcionario              = sa.cd_funcionario
  left outer join finalidade_adiantamento fa with (nolock) on fa.cd_finalidade_adiantamento = sa.cd_finalidade_adiantamento
  left outer join Moeda mo                   with (nolock) on mo.cd_moeda                   = sa.cd_moeda
  left outer join Tipo_Adiantamento ta       with (nolock) on ta.cd_tipo_adiantamento       = sa.cd_tipo_adiantamento
where
  sa.cd_funcionario                  = case when @cd_funcionario    = 0 then sa.cd_funcionario              else @cd_funcionario    end and
  isnull(sa.cd_cartao_credito,0)     = case when @cd_cartao_credito = 0 then isnull(sa.cd_cartao_credito,0) else @cd_cartao_credito end and
  isnull(sa.vl_saldo_adiantamento,0) > 0 and
  isnull(sa.cd_prestacao,0)          = 0
order by
  sa.dt_vencimento

