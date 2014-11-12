
CREATE PROCEDURE pr_baixar_documento_pagar

@cd_documento_pagar 		int,
@dt_pagamento_documento		datetime,
@vl_pagamento_documento 	decimal(25,2),
@cd_identifica_documento	varchar(50),
@vl_juros			decimal(25,2),
@vl_desconto			decimal(25,2),
@vl_abatimento			decimal(25,2),
@cd_recibo			varchar(10),
@cd_tipo_documento		int,
@cd_usuario			int

AS
begin

  declare @vl_total_pagamento decimal(25,2)
  declare @cd_item_pagamento  int
  set	  @vl_total_pagamento = 0
  set     @cd_item_pagamento = 0

  begin transaction
  
  --Verificando se Documento já foi baixado
  if(select
       cast(vl_saldo_documento_pagar as decimal(25,2))
     from
       Documento_Pagar
     where
       cd_documento_pagar = @cd_documento_pagar) = 0
  begin
    raiserror('Documento já liquidado! Operação Abortada!',16,1)
    return
  end
  else
  begin

    set @vl_total_pagamento = (@vl_pagamento_documento - @vl_juros + @vl_abatimento + @vl_desconto)
    --Verificando se Valores Informados são maiores que saldo a pagar    


    if @vl_total_pagamento > (select
                                cast(vl_saldo_documento_pagar as decimal(25,2))
                              from
                                Documento_Pagar
                              where
                                cd_documento_pagar = @cd_documento_pagar)
    begin
      raiserror('Valor do Pagamento é Superior ao Saldo a Pagar', 16, 1)
      return
    end
    else
    begin
      -- encontrando código do ítem
      select 
        @cd_item_pagamento = (isnull(max(cd_item_pagamento),0)+1)
      from
        Documento_Pagar_Pagamento
      where
        cd_documento_pagar = @cd_documento_pagar
      
      print(@cd_item_pagamento) 
       
      --Gravando Item de Pagamento do Documento
      insert into Documento_Pagar_Pagamento (
        cd_documento_pagar,
        cd_item_pagamento,
        dt_pagamento_documento,
        vl_pagamento_documento,
        cd_identifica_documento,
        vl_juros_documento_pagar,
        vl_desconto_documento,
        vl_abatimento_documento,
        cd_recibo_documento,
        cd_tipo_pagamento,
        cd_usuario,
        dt_usuario )
      values
      (
        @cd_documento_pagar,
        @cd_item_pagamento,
        @dt_pagamento_documento,
        @vl_pagamento_documento,
        @cd_identifica_documento,
        @vl_juros,
        @vl_desconto,
        @vl_abatimento,
        @cd_recibo,
        @cd_tipo_documento,
        @cd_usuario,
        getdate()
      )

      --Atualizando Campo Saldo Documento Pagar
      update
        Documento_Pagar
      set
        vl_saldo_documento_pagar = ((select
                                      cast(vl_saldo_documento_pagar as decimal(25,2))
                                    from
                                      Documento_Pagar
                                    where
                                      cd_documento_Pagar = @cd_documento_pagar) -
                                    @vl_total_pagamento),
        cd_usuario = @cd_usuario,
        dt_usuario = getdate()
      where
        cd_documento_pagar = @cd_documento_pagar
      
    end
  end
  
  if @@ERROR = 0
  begin
    commit tran
  end
  else
  begin
    --raiserror(@@ERROR, 16, 1)
    rollback tran
  end
  
  --Caso fique alguma transação aberta
  if @@TRANCOUNT > 0
    commit tran 

end
