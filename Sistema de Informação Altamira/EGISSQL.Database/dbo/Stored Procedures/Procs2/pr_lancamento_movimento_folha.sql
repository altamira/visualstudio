
-------------------------------------------------------------------------------
--sp_helptext pr_lancamento_movimento_folha
-------------------------------------------------------------------------------
--pr_lancamento_movimento_folha
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Lançamento do Movimento da Folha de Pagamento
--Data             : 12.06.2008
--Alteração        : 
--
-- 07.01.2011 - Ajustes Diversos - Carlos Fernandes
-- 24.01.2011 - Tipo de Lancamento - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_lancamento_movimento_folha
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@ic_tipo_lancamento char(1) = 'M'

as

--select * from movimento_folha

select
  mf.*,
  f.nm_funcionario,
  ef.nm_evento,
  te.nm_tipo_evento
from
  movimento_folha mf              with (nolock)
  left outer join Funcionario f   with (nolock) on f.cd_funcionario  = mf.cd_funcionario
  left outer join Evento_Folha ef with (nolock) on ef.cd_evento      = mf.cd_evento
  left outer join Tipo_Evento  te with (nolock) on te.cd_tipo_evento = ef.cd_tipo_evento
where

  mf.dt_lancamento_folha between @dt_inicial and @dt_final
  and
  mf.ic_tipo_lancamento  = @ic_tipo_lancamento




