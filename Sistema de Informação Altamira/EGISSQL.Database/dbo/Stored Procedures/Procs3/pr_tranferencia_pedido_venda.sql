
CREATE PROCEDURE pr_tranferencia_pedido_venda
@cd_pedido_origem int,
@Destino        varchar(50),
@cd_usuario     int
as

declare @cd_pedido_venda int,
        @CMDDestino varchar(1000),
        @TabDestino varchar(50)

--Verifica se não é zero

if not  @cd_pedido_origem = 0
begin
     BEGIN DISTRIBUTED TRANSACTION
     --Pega o nome da tabela do Pedido Venda Destino
     set @TabDestino = cast(@Destino +'.dbo.Pedido_Venda' as varchar(50))
      
     exec EgisADMIN.dbo.sp_PegaCodigo @TabDestino, 'cd_pedido_venda', @codigo = @cd_pedido_venda output

     --Verifica se Existe o Pedido na Tabela

     --Cria a Tabela temporario
     select cd_pedido_venda 
     into #VerificaDestino 
     from Pedido_Venda 
     where  1=2

     set @CMDDestino =  'select cd_pedido_venda into #VerificaDestino from '+ @TabDestino +' where  cd_pedido_venda = ' + cast(@cd_pedido_venda as Varchar(50))
     execute(@CMDDestino)

     if not exists(select cd_pedido_venda from #VerificaDestino)
     begin
          Select * into #PedidoLocal from Pedido_Venda
          where cd_pedido_venda = @cd_pedido_origem

            
          --Geração um Novo Pedido

          update
             #PedidoLocal
          set
            cd_pedido_venda        = @cd_pedido_venda,
            cd_usuario             = @cd_usuario,
            dt_usuario             = getdate()

          set @CMDDestino = 'insert into ' 
                           + @TabDestino +  
                           ' select * from #PedidoLocal'

          exec(@CMDDestino)      


         set @TabDestino = cast(@Destino +'.dbo.Pedido_Venda_Item' as varchar(50))
      
         --Cria uma Tabela Temporária - Itens do Pedido de Venda
         select * into #Pedido_Itens_Local 
         from Pedido_Venda_Item
         where cd_pedido_venda = @cd_pedido_origem

         --Geração da Nova Tabela de Itens do Pedido

       update
          #Pedido_Itens_Local
       set
         cd_pedido_venda           = @cd_pedido_venda,
         cd_usuario                = @cd_usuario,
         dt_usuario                = getdate()


       Set @CMDDestino = 'insert into ' + 
                        @TabDestino + 
                        ' select * from #Pedido_Itens_Local'

       exec(@CMDDestino)

       --Realiza a cópia das tabelas complementares do Pedido
       exec dbo.pr_tranferencia_pedido_venda_complementar @cd_pedido_origem,@Destino, @cd_pedido_venda, @cd_usuario  

      if (@@error <> 0)
      begin
           ROLLBACK TRANSACTION 
      end
      else
      begin
           Commit transaction 
           Select  NovoPedido = @cd_pedido_venda
      end
  end
end

