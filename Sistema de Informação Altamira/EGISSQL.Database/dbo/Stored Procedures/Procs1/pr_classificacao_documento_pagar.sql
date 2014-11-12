
CREATE PROCEDURE pr_classificacao_documento_pagar
@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime

as

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- listagem dos grupos de documento a pagar por classificacao
-------------------------------------------------------------------------------
  begin

    select
      c.nm_tipo_conta_pagar		as 'Classificacao',
      count(d.cd_documento_pagar)	as 'Qtd',
      sum(d.vl_documento_pagar)		as 'VlrDocumento',
      sum(d.vl_saldo_documento_pagar)	as 'VlrAberto',
      ((sum(d.vl_saldo_documento_pagar)/sum(d.vl_documento_pagar))*100)
					as 'PercAberto',
      sum(p.vl_pagamento_documento)	as 'VlrBaixado',
      ((sum(p.vl_pagamento_documento)/sum(d.vl_documento_pagar))*100)
					as 'PercBaixado'   
    from
      tipo_conta_pagar c
    left outer join
      documento_pagar d
    on
      c.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar
    left outer join
      documento_pagar_pagamento p
    on
      d.cd_documento_pagar = p.cd_documento_pagar
    where
      d.dt_vencimento_documento between @dt_inicial and @dt_final
    group by
      c.nm_tipo_conta_pagar     

  end
else
  return
      

