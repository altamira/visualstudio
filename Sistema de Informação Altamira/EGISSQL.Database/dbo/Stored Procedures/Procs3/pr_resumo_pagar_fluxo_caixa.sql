
CREATE PROCEDURE pr_resumo_pagar_fluxo_caixa
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

as

-------------------------------------------------------------------------------
if @ic_parametro = 1  
-------------------------------------------------------------------------------
  begin

    select
      d.dt_vencimento_documento         as 'DataVencimento',
      count(d.cd_documento_pagar)	as 'Qtd',
      sum(d.vl_documento_pagar)		as 'VlrDocumento',
      sum(d.vl_saldo_documento_pagar)	as 'VlrAberto',
      ((sum(d.vl_saldo_documento_pagar)/sum(d.vl_documento_pagar))*100)
					as 'PercAberto',
      sum(p.vl_pagamento_documento)	as 'VlrBaixado',
      ((sum(p.vl_pagamento_documento)/sum(d.vl_documento_pagar))*100)
					as 'PercBaixado'   
    from
      documento_pagar d
    left outer join
      documento_pagar_pagamento p
    on
      d.cd_documento_pagar = p.cd_documento_pagar
    where
      d.dt_vencimento_documento between @dt_inicial and @dt_final and
      d.dt_cancelamento_documento is null
    group by
     d.dt_vencimento_documento

  end
else
  return
      

--sp_help documento_pagar
--sp_help documento_pagar
