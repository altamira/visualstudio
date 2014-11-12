
-------------------------------------------------------------------------------
--sp_helptext pr_fechamento_caixa_usuario
-------------------------------------------------------------------------------
--pr_fechamento_caixa_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Fechamento do Movimento de Caixa do Usuário
--
--Data             : 05.02.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_fechamento_caixa_usuario
@cd_operador_caixa int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = ''

as

--select * from movimento_caixa_recebimento
--select * from tipo_lancamento_caixa
--select * from nota_saida

select
  oc.nm_operador_caixa,
  tlc.nm_tipo_lancamento,
  ns.nm_razao_social_nota            as Cliente,
  mc.cd_documento                    as Documento,
  mc.vl_movimento_recebimento        as Valor,
  mc.nm_obs_movimento_caixa          as Observacao,
  hr.nm_historico_recebimento,
  mc.nm_historico_complemento
  
from
  movimento_caixa_recebimento mc            with (nolock) 
  left outer join Operador_Caixa        oc  with (nolock) on oc.cd_operador_caixa        = mc.cd_operador_caixa
  left outer join Tipo_Lancamento_Caixa tlc with (nolock) on tlc.cd_tipo_lancamento      = mc.cd_tipo_lancamento
  left outer join Nota_Saida            ns  with (nolock) on ns.cd_nota_saida            = mc.cd_nota_saida
  left outer join Veiculo               v   with (nolock) on v.cd_veiculo                = mc.cd_veiculo
  left outer join Motorista             m   with (nolock) on m.cd_motorista              = mc.cd_motorista
  left outer join Historico_Recebimento hr  with (nolock) on hr.cd_historico_recebimento = mc.cd_historico_recebimento
where
  mc.dt_movimento_caixa between @dt_inicial and @dt_final and
  mc.cd_operador_caixa = case when @cd_operador_caixa = 0 then mc.cd_operador_caixa else @cd_operador_caixa end


--select * from historico_recebimento

