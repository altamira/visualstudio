

create procedure pr_estornar_bordero

--------------------------------------------------------- 
--GBS - Global Business Solution              2002 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es) : Elias Pereira da Silva 
--Banco de Dados : EGISSQL 
--Objetivo : Estornar Borderôs a Pagar.
--Data : 11/10/2002 
-- Atualizado: 19/11/2002 - Acerto de Filtro - Elias.
--             20/11/2002 - Colocado para gravar usuário e data no documentos a pagar - Daniel C. Neto.
------------------------------------------------------------------------------ 

@cd_bordero int,
@cd_usuario int

as

  declare @cd_documento_pagar int

  select 
    *
  into
    #Documento_Bordero 
  from
    documento_pagar_pagamento
  where
    cd_identifica_documento = cast(@cd_bordero as varchar) and
    cd_tipo_pagamento = 1

  while exists(select top 1 cd_documento_pagar from #Documento_Bordero)
    begin

      select 
        top 1
        @cd_documento_pagar = cd_documento_pagar
      from
        #Documento_Bordero

      delete 
        documento_pagar_pagamento
      where
        cd_documento_pagar = @cd_documento_pagar
   
      update
        documento_pagar
      set
        vl_saldo_documento_pagar = vl_documento_pagar,
        cd_usuario = @cd_usuario,
        dt_usuario = GetDate()
      where
        cd_documento_pagar = @cd_documento_pagar

      delete from
        #Documento_Bordero
      where
        cd_documento_pagar = @cd_documento_pagar

    end

  delete from
    Bordero
  where
    cd_bordero = @cd_bordero
         

