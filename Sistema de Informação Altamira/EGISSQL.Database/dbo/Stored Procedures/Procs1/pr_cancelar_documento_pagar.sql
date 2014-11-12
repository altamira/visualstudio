
CREATE PROCEDURE pr_cancelar_documento_pagar
@cd_documento_pagar        int,
@dt_cancelamento_documento datetime,
@nm_cancelamento_documento varchar(30),
@cd_usuario                int

as

begin transaction

  -- verifica se documento já foi baixado
  if exists(select top 1 * from documento_pagar_pagamento where cd_documento_pagar = @cd_documento_pagar)
    begin
      raiserror('Cancelamento não permitido. Documento já Liquidado (Total ou Parcial). Operação Abortada!', 16, 1) 
      goto TratarErro
    end

  -- verifica se documento já foi baixado
  if exists(select top 1 * from documento_pagar where cd_documento_pagar = @cd_documento_pagar and cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) = 0)
-- linha acima convertida para decimal.

    begin
      raiserror('Cancelamento não permitido. Documento já Liquidado (Total ou Parcial). Operação Abortada!', 16, 1)
      goto TratarErro
    end

  -- cancelamento do documento
  update
    documento_pagar   
  set
    dt_cancelamento_documento = @dt_cancelamento_documento,
    nm_cancelamento_documento = @nm_cancelamento_documento,
    cd_usuario = @cd_usuario,
    dt_usuario = getDate() 
  where
    cd_documento_pagar = @cd_documento_pagar

  TratarErro:  
  if @@ERROR = 0
    begin
      commit tran
    end
  else
    begin
      --raiserror(@@ERROR, 16, 1)
      rollback tran
    end  

  --Write your procedures's statement here
