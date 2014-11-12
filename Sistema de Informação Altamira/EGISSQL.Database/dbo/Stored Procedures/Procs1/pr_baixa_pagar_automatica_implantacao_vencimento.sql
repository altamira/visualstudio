
-------------------------------------------------------------------------------
--sp_helptext pr_baixa_pagar_automatica_implantacao_vencimento
-------------------------------------------------------------------------------
--pr_baixa_pagar_automatica_implantacao_vencimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Baixa de Documentos a Pagar
--Data             : 29.07.2008
--Alteração        : 14.09.2010 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_baixa_pagar_automatica_implantacao_vencimento
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--documento_pagar_pagamento
--select * from documento_pagar
--select * from tipo_pagamento_documento

select
  d.cd_documento_pagar,
  1 as cd_item_pagamento,
  d.dt_vencimento_documento     as dt_pagamento_documento,
  d.vl_documento_pagar          as vl_pagamento_documento,
  null                          as cd_identifica_documento,
  0.00                          as vl_juros_documento_pagar,
  0.00                          as vl_desconto_documento,
  0.00                          as vl_abatimento_documento,
  null                          as cd_recibo_documento,
  7                             as cd_tipo_pagamento,
  'Geraçao Automática Migração' as nm_obs_documento_pagar,
   null                         as ic_deposito_conta,
   4 as cd_usuario,
   getdate() as dt_usuario,
   null                         as dt_fluxo_doc_pagar_pagto,
   null                         as cd_conta_banco,
   null                         as nm_contrato_cambio,
   null                         as dt_moeda,
   null                         as vl_moeda,
   null                         as vl_tarifa_contrato_cambio,
   null                         as cd_fechamento_cambio,
   null                         as cd_contrato_cambio,
  1  as cd_moeda,
   null                         as ic_fechamento_cambio,
   null                         as cd_lancamento,
   null                         as cd_lancamento_caixa,
   null                         as cd_tipo_caixa,
   null                         as vl_multa_documento_pagamento,
   null                         as nm_obs_compl_documento


into
 #documento_pagar_pagamento

from
  documento_pagar d with (nolock) 
where
  dt_vencimento_documento between @dt_inicial and @dt_final
  and isnull(vl_saldo_documento_pagar,0) > 0

delete from documento_pagar_pagamento
where
  cd_documento_pagar in ( select cd_documento_pagar from #documento_pagar_pagamento )
 
insert into
 documento_pagar_pagamento
select
  *
from
  #documento_pagar_pagamento


update
  documento_pagar
set
  vl_saldo_documento_pagagar = 0
from
  documento_pagar
where
  cd_documento_pagar in ( select cd_documento_pagar from #documento_pagar_pagamento ) and
  isnull(vl_saldo_documento_pagar,0)>0
  and   dt_vencimento_documento between @dt_inicial and @dt_final


select * from #documento_pagar_pagamento

