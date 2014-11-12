

/****** Object:  Stored Procedure dbo.pr_acerto_saldo_documento_pagar    Script Date: 13/12/2002 15:08:11 ******/
create procedure pr_acerto_saldo_documento_pagar
as

-- acerta os saldos que foram migrados mesmo c/ pagamento total

select 
  cd_documento_pagar 
into
  #documento_pagar
from 
  documento_pagar d
where 
  d.vl_saldo_documento_pagar = (select 
                                  sum(isnull(p.vl_pagamento_documento,0))+
                                  sum(isnull(p.vl_juros_documento_pagar,0))-
                                  sum(isnull(p.vl_desconto_documento,0)) -
                                  sum(isnull(p.vl_abatimento_documento,0))
                                from
                                  documento_pagar_pagamento p
                                where
                                  p.cd_documento_pagar = d.cd_documento_pagar) and
  d.dt_cancelamento_documento is null

update
  documento_pagar
set
  vl_saldo_documento_pagar = 0
where
  cd_documento_pagar in (select 
                           cd_documento_pagar
                         from
                           #documento_pagar)                           



