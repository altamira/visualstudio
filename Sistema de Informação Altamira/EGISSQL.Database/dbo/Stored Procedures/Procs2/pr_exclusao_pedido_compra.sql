
CREATE PROCEDURE pr_exclusao_pedido_compra
------------------------------------------------------------------------------------------------------
-- GBS - Global Business Sollution             2003
---------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto 
--Banco de Dados: EgisSql
--Objetivo: Exclusão de Pedido de Compra e de todas as tabelas
--          relacionadas. 
--Data: 23/10/2003
--Atualizado: 
--Márcio - 17/05/2005 - Correção da Rotina 5, ao criar a tabela temporaria sendo vazia entrava em looping continuo.
-- 06.07.2007 - Verifica a baixa da quantidade do pedido na tabela produto_saldo 
--              Na exclusão não pode ser feita, porque o cancelamento faz fez - Carlos Fernandes
------------------------------------------------------------------------------------------------------


@ic_parametro integer = 0,
@cd_pedido    integer = 0

AS

if @cd_pedido>0
begin

  if @ic_parametro = 1
    delete from Pedido_Compra_Aprovacao where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 2
    delete from Pedido_Compra_Follow where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 3
    delete from Pedido_Compra_Historico where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 4
    delete from Centro_Custo_Pedido_Compra where cd_pedido_compra = @cd_pedido

  -- Retornando cotações e requisições de compra geradas.

  else if @ic_parametro = 5
    begin
      declare @cd_requisicao_compra int
   
	   select distinct cd_requisicao_compra 
		into #Requisicao
      from Pedido_Compra_Item
      where cd_pedido_compra = @cd_pedido

      set @cd_requisicao_compra = isnull((select top 1 cd_requisicao_compra from #Requisicao ),0)
      print('@cd_requisicao_compra '+cast(@cd_requisicao_compra as varchar))					

      if not (@cd_requisicao_compra = Null) or not (@cd_requisicao_compra = 0)
      begin      
           while exists (select top 1 cd_requisicao_compra from #Requisicao)
           begin
                set @cd_requisicao_compra = (select top 1 cd_requisicao_compra from #Requisicao )      
					
                if (@cd_requisicao_compra = Null)
						 continue
          
                update Cotacao_Item
	  						set ic_pedido_compra_cotacao = 'N'
	  						where cd_requisicao_compra = @cd_requisicao_compra

         		 update Requisicao_Compra_Item
          		 set cd_pedido_compra = Null,
              		  cd_item_pedido_compra = Null
	  				 where cd_requisicao_compra = @cd_requisicao_compra

	  		 				delete #Requisicao where cd_requisicao_compra = @cd_requisicao_compra
		   		end
      end

  end

  --Atualização da Tabela Produto Saldo
  --	
  --Comentado em 06.07.2007 - Carlos Fernandes.

--   else if @ic_parametro = 6
--     begin
-- 
--       
--       declare @cd_produto            int
--       declare @qt_item_pedido_compra int
-- 
--       select cd_produto, 
--              sum(IsNull(qt_item_pedido_compra,0)) as qt_item_pedido_compra
--       into #Pedido_Compra_Item
--       from Pedido_Compra_Item
--       where cd_pedido_compra = @cd_pedido and
--             IsNull(cd_produto,0) <> 0
--       group by cd_produto
-- 
--       while exists ( select top 1 * from #Pedido_Compra_Item)
--       begin
-- 
--         set @cd_produto = ( select top 1 cd_produto from #Pedido_Compra_Item)
-- 	set @qt_item_pedido_compra = ( select top 1 qt_item_pedido_compra from #Pedido_Compra_Item
-- 				       where cd_produto = @cd_produto)
-- 
--         update Produto_Saldo
-- 	set qt_req_compra_produto =  IsNull(qt_req_compra_produto,0) + @qt_item_pedido_compra,
-- 	    qt_pd_compra_produto  =  IsNull(qt_pd_compra_produto,0)  - @qt_item_pedido_compra
-- 	where cd_produto = @cd_produto
-- 
--         delete from #Pedido_Compra_Item where cd_produto = @cd_produto
-- 
--       end
--    end

  else if @ic_parametro = 7
    update Requisicao_Compra 
    set cd_pedido_compra = Null,
	cd_item_pedido_compra = Null
    where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 8
    delete from Pedido_Compra where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 9
    delete from Historico_Compra_Produto where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 10
    delete from Pedido_Compra_Item where cd_pedido_compra = @cd_pedido

  else if @ic_parametro = 11
    --Atualizando todos os pedidos de importação.
    update 
      Pedido_Importacao_item
    set cd_pedido_compra      = Null,
        cd_item_pedido_compra = Null
    where 
      cd_pedido_compra = @cd_pedido

end

