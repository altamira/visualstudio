

create procedure pr_zera_saldo_documento_pagar

@cd_parametro int

as

if @cd_parametro = 1
begin
  select dp.cd_documento_pagar,
         d.cd_identificacao_document,
         d.dt_vencimento_documento,
         dp.dt_pagamento_documento,
         d.vl_documento_pagar,
        (dp.vl_pagamento_documento-dp.vl_juros_documento_pagar+
         dp.vl_desconto_documento+dp.vl_abatimento_documento) as vl_pago,
         d.vl_saldo_documento_pagar, 
         dp.vl_juros_documento_pagar,
         dp.vl_desconto_documento,        
         dp.vl_abatimento_documento,
         d.vl_juros_documento,
         d.vl_desconto_documento,        
         d.vl_abatimento_documento

  from documento_pagar_pagamento dp,
       documento_pagar d

  where dp.cd_documento_pagar = d.cd_documento_pagar and
        dp.dt_pagamento_documento is not null and
        d.vl_saldo_documento_pagar > 0

  order by d.dt_vencimento_documento
end

if @cd_parametro = 2
begin
  update documento_pagar 
  set vl_saldo_documento_pagar = 0
  from documento_pagar_pagamento a, documento_pagar b
  where a.dt_pagamento_documento is not null and
        a.cd_documento_pagar = b.cd_documento_pagar and
        b.vl_saldo_documento_pagar > 0
end


