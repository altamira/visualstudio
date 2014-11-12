
-------------------------------------------------------------------------------
--sp_helptext pr_solicitacao_adiantamento_aberto_funcionario
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Verificação das Solicitações de Adiantamento em Aberto
--                   por funcionário
--Data             : 14.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_solicitacao_adiantamento_aberto_funcionario
@cd_funcionario  int = 0,
@cd_centro_custo int = 0
as

--select * from solicitacao_adiantamento
--select * from prestacao_conta

if @cd_funcionario>0
begin

  select
    sa.cd_funcionario,
    count(*)                                 as qt_solicitacao_aberto,
    sum( isnull(sa.vl_saldo_adiantamento,0)) as Saldo
  from
    Solicitacao_Adiantamento sa   with (nolock)
  where
    sa.cd_funcionario  = case when @cd_funcionario  = 0 then sa.cd_funcionario  else @cd_funcionario  end and
    sa.cd_centro_custo = case when @cd_centro_custo = 0 then sa.cd_centro_custo else @cd_centro_custo end and
    isnull(sa.vl_saldo_adiantamento,0) > 0 and
    ( isnull(sa.cd_prestacao,0)=0 or 
      isnull(sa.cd_prestacao,0) not in ( select cd_prestacao from prestacao_conta where dt_fechamento_prestacao is not null and
                                                                                        dt_conf_prestacao is not null ) )
  group by
    sa.cd_funcionario

end

