
create procedure pr_atualiza_packing_list

@cd_identificacao_pedido VarChar(20),
@cd_item_ped_imp Int,
@qt_peso Float

as
Begin

  Declare @qt_peso_arquivo Float

  Set @qt_peso_arquivo = 0

  if charindex('-',@cd_identificacao_pedido,1)-1 > 0 
    set @cd_identificacao_pedido = substring(@cd_identificacao_pedido,1,charindex('-',@cd_identificacao_pedido,1)-1)

  If Exists (Select 'x'
             from Arquivo_Texto_Invoice_Item 
             where Left(cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido) and
                 --cd_identificacao_pedido = @cd_identificacao_pedido and
                   cd_item_ped_imp = @cd_item_ped_imp)                      
    Begin
      Update Arquivo_Texto_Invoice_Item set qt_peso_arquivo = IsNull(qt_peso_arquivo,0) + @qt_peso
	    where Left(cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido) and
                --cd_identificacao_pedido = @cd_identificacao_pedido and
	          cd_item_ped_imp = @cd_item_ped_imp                      

      Select @qt_peso_arquivo = qt_peso_arquivo
      from Arquivo_Texto_Invoice_Item 
      where Left(cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido) and
          --cd_identificacao_pedido = @cd_identificacao_pedido and
            cd_item_ped_imp = @cd_item_ped_imp                      

      Select @qt_peso = @qt_peso_arquivo         
    End
  Else
    Update Arquivo_Texto_Invoice_Item set qt_peso_arquivo = @qt_peso
    Where Left(cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido) and
        --cd_identificacao_pedido = @cd_identificacao_pedido and
          cd_item_ped_imp = @cd_item_ped_imp

  If @qt_peso > 0 
    Update Arquivo_Texto_Invoice_Item set qt_peso = (@qt_peso / qt_item_arquivo_texto)
    Where Left(cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido) and
        --cd_identificacao_pedido = @cd_identificacao_pedido and
          cd_item_ped_imp = @cd_item_ped_imp
--  Else
--    Update Arquivo_Texto_Invoice_Item set qt_peso = @qt_peso
--    Where cd_identificacao_pedido = @cd_identificacao_pedido and
--          cd_item_ped_imp = @cd_item_ped_imp
End

--select * from Arquivo_Texto_Invoice_Item

--------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------
--exec pr_atualiza_packing_list

