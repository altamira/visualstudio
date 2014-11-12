
create procedure pr_exclusao_bordero_pagar
@cd_bordero int

as

  declare @cd_tipo_pagamento_bordero int

  set @cd_tipo_pagamento_bordero = 0

  -- tipo do pagamento (BORDERÔ)
  select
    @cd_tipo_pagamento_bordero = min(cd_tipo_pagamento)
  from
    tipo_pagamento_documento
  where
    sg_tipo_pagamento like 'BORDER%'

begin transaction


  -- permitir a exclusão somente dos borderôs que não foram baixados
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
  else
    begin
      -- antes de excluir os pagamentos do borderô, acertar os documentos quanto aos
      -- valores de juros, desconto e abatimento

      declare @cd_documento_pagar       int
      declare @vl_juros_documento_pagar float
      declare @vl_desconto_documento    float
      declare @vl_abatimento_documento  float

      set     @cd_documento_pagar       = 0
      set     @vl_juros_documento_pagar = 0
      set     @vl_desconto_documento    = 0
      set     @vl_abatimento_documento  = 0

      select
        cd_documento_pagar,
        vl_juros_documento_pagar,
        vl_desconto_documento,
        vl_abatimento_documento
      into
        #documento_pagar_pagamento
      from
        documento_pagar_pagamento
      where
        cd_tipo_pagamento = @cd_tipo_pagamento_bordero and
        cd_identifica_documento = cast(@cd_bordero as varchar(50)) 

      -- excluir pagamentos do borderô
      delete from
        documento_pagar_pagamento
      where
        cd_tipo_pagamento = @cd_tipo_pagamento_bordero and
        cd_identifica_documento = cast(@cd_bordero as varchar(50)) 
      
      while exists(select top 1 cd_documento_pagar from #documento_pagar_pagamento)
        begin
       
          select 
            @cd_documento_pagar       = cd_documento_pagar,
            @vl_juros_documento_pagar = isnull(vl_juros_documento_pagar,0),
            @vl_desconto_documento    = isnull(vl_desconto_documento,0), 
            @vl_abatimento_documento  = isnull(vl_abatimento_documento,0)
          from
            #documento_pagar_pagamento

          -- atualizando o documento
          if ((@vl_juros_documento_pagar <> 0) or
            (@vl_desconto_documento <> 0) or
            (@vl_abatimento_documento <> 0))          
            update
              documento_pagar
            set
              vl_juros_documento = @vl_juros_documento_pagar,
              vl_desconto_documento = @vl_desconto_documento,
              vl_abatimento_documento = @vl_abatimento_documento,
              vl_saldo_documento_pagar = (cast(str(vl_documento_pagar,25,2) as decimal(25,2)) -
                                         (select 
                                            isnull(sum(cast(str(vl_pagamento_documento,25,2) as decimal(25,2))),0) -
                                            isnull(sum(cast(str(vl_juros_documento_pagar,25,2) as decimal(25,2))),0) +
                                            isnull(sum(cast(str(vl_desconto_documento,25,2) as decimal(25,2))),0) +
                                            isnull(sum(cast(str(vl_abatimento_documento,25,2) as decimal(25,2))),0)
                                          from
                                            documento_pagar_pagamento
                                          where
                                            cd_documento_pagar = @cd_documento_pagar) +
                                          cast(str(@vl_juros_documento_pagar,25,2) as decimal(25,2)) -
                                          cast(str(@vl_desconto_documento,25,2) as decimal(25,2)) -
                                          cast(str(@vl_abatimento_documento,25,2) as decimal(25,2)))
            where
              cd_documento_pagar = @cd_documento_pagar

          delete from 
            #documento_pagar_pagamento
          where
            cd_documento_pagar = @cd_documento_pagar

        end              

      -- excluir bordero
      delete from
        bordero
      where
        cd_bordero = @cd_bordero                 
    end

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

