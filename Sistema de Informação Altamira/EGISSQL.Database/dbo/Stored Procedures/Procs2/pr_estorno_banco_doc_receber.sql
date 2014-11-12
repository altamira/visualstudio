

create procedure pr_estorno_banco_doc_receber

@cd_parametro int,
@cd_banco     int,
@dt_retorno   datetime

as

if @cd_parametro = 1
begin

  select d.cd_documento_receber,
         d.cd_identificacao,
         d.dt_vencimento_documento,
         d.vl_documento_receber,
         d.vl_saldo_documento,
         d.cd_banco_documento,
         dp.cd_banco,
         dp.dt_pagamento_documento,
         dp.vl_pagamento_documento,
         dp.vl_juros_pagamento,
         dp.vl_desconto_documento,
         dp.vl_abatimento_documento,
         dp.vl_despesa_bancaria,
         dp.vl_reembolso_documento 

  from documento_receber d,
       documento_receber_pagamento dp

  where d.dt_retorno_banco_doc >= @dt_retorno and
        d.cd_documento_receber = dp.cd_documento_receber --and
--        isnull(dp.cd_banco,d.cd_banco_documento) = @cd_banco

  order by d.cd_identificacao

end

if @cd_parametro = 2
begin

  declare @vl_pago_documento float
/*  
  update documento_receber
  set vl_saldo_documento_pagar = @vl_pago_documento

  from documento_pagar_pagamento a, documento_pagar b
  where a.dt_pagamento_documento is not null and
        a.cd_documento_pagar = b.cd_documento_pagar and
        b.vl_saldo_documento_pagar > 0
*/
end


