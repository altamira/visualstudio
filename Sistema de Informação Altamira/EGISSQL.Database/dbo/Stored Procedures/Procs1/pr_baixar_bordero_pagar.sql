
create procedure pr_baixar_bordero_pagar
@cd_bordero int,
@dt_liquidacao datetime,
@cd_usuario int
as

  declare @cd_tipo_pagamento_bordero int
  declare @cd_documento_pagar int
  declare @vl_pagamento_documento float

  set @cd_tipo_pagamento_bordero = 0

  -- tipo do pagamento (BORDERÔ)
  select
    @cd_tipo_pagamento_bordero = min(cd_tipo_pagamento)
  from
    tipo_pagamento_documento
  where
    sg_tipo_pagamento like 'BORDER%'

begin transaction


  -- permitir a baixa somente dos borderôs que não foram baixados
  if (select
        ic_baixado_bordero
      from
        bordero
      where
        cd_bordero = @cd_bordero) = 'S'
    begin
      raiserror('Borderô já Liquidado! Operação Cancelada!', 16, 1)
      goto TrataErro
    end

  --Tabela temporária com documentos a pagar do bordero informado
  select
    cd_documento_pagar,
    vl_pagamento_documento
  into
    #Documento_Bordero
  from
    Documento_Pagar_Pagamento
  where
    cd_tipo_pagamento = @cd_tipo_pagamento_bordero
    and cd_identifica_documento = cast(@cd_bordero as varchar(20))


  --Atualiza Saldo dos Documentos a Pagar do Bordero
  while exists(select top 1 'x' from #Documento_Bordero)
  begin
    
    select
      @cd_documento_pagar = cd_documento_pagar,
      @vl_pagamento_documento = vl_pagamento_documento
    from
      #Documento_Bordero    

    update 
      Documento_Pagar
    set
      vl_saldo_documento_pagar = @vl_pagamento_documento - vl_saldo_documento_pagar,
      cd_usuario = @cd_usuario,
      dt_usuario = getDate()
    where
      cd_documento_pagar = @cd_documento_pagar

    delete from
      #Documento_Bordero
    where
      cd_documento_pagar = @cd_documento_pagar    
  end

  --Atualiza Borderô
  update
    bordero
  set
    ic_baixado_bordero = 'S',
    dt_liquidacao_bordero = @dt_liquidacao,
    cd_usuario = @cd_usuario,
    dt_usuario = getDate()
  where
    cd_bordero = @cd_bordero

  --Atualiza a data de pagamento em documento_pagar_pagamento
  update
    documento_pagar_pagamento
  set
    dt_pagamento_documento = @dt_liquidacao
  where
    cd_tipo_pagamento = @cd_tipo_pagamento_bordero
    and cd_identifica_documento = cast(@cd_bordero as varchar(20))

  -- atualizando banco de dados    
  TrataErro:
    if @@ERROR = 0
      begin
        commit tran
      end
    else
      begin
        --raiserror(@@ERROR, 16, 1)
        rollback tran
      end

