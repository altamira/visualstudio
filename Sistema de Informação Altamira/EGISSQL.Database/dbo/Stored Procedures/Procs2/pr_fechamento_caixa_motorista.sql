
-------------------------------------------------------------------------------
--sp_helptext pr_fechamento_caixa_motorista
-------------------------------------------------------------------------------
--pr_fechamento_caixa_motorista
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Fechamento do Movimento de Caixa do Motorista
--
--Data             : 05.02.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_fechamento_caixa_motorista
@cd_motorista      int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = ''

as

--select * from movimento_caixa_recebimento
--select * from tipo_lancamento_caixa
--select * from nota_saida
--select * from nota_saida

select
  ns.cd_motorista,
  sum(ns.vl_total) as Valor_Total_Receber
into
  #MovimentoReal
from
  Nota_Saida ns with (nolock)
  left outer Join Cliente c                     on c.cd_cliente          = ns.cd_cliente
  left outer Join Cliente_Informacao_Credito ci on ci.cd_cliente         = c.cd_cliente
  left outer join Forma_Pagamento            fp on fp.cd_forma_pagamento = ns.cd_forma_pagamento

--select * from forma_pagamento

where
  ns.cd_motorista = case when @cd_motorista = 0 then ns.cd_motorista else @cd_motorista end and
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.dt_cancel_nota_saida is null                    and
  isnull(fp.ic_caixa_forma_pagamento,'N')='S'

group by
  ns.cd_motorista

--Mostra o Motorista

select
  m.cd_motorista,
  m.nm_motorista,
  sum(mc.vl_movimento_recebimento)                        as Valor_Caixa,
  sum(isnull(mr.Valor_Total_Receber,0))                   as Valor_Receber,
  0.00                                                    as Valor_Credito,
  0.00                                                    as Valor_Debito,
  0.00                                                    as Saldo



  
from
  movimento_caixa_recebimento mc            with (nolock) 
  left outer join Tipo_Lancamento_Caixa tlc with (nolock) on tlc.cd_tipo_lancamento      = mc.cd_tipo_lancamento
  left outer join Motorista             m   with (nolock) on m.cd_motorista              = mc.cd_motorista
  left outer join #MovimentoReal mr         with (nolock) on mr.cd_motorista             = mc.cd_motorista
where
  mc.dt_movimento_caixa between @dt_inicial and @dt_final                                   and
  mc.cd_motorista = case when @cd_motorista = 0 then mc.cd_motorista else @cd_motorista end and
  isnull(tlc.ic_motorista_caixa,'N')='S'
 
group by
  m.cd_motorista,
  m.nm_motorista
  

--select * from tipo_lancamento_caixa
--select * from historico_recebimento

