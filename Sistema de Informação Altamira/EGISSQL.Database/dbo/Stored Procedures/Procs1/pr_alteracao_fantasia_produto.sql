

CREATE  PROCEDURE pr_alteracao_fantasia_produto
@cd_produto int,
@nm_fantasia_produto varchar(15)
AS
Begin
   Declare 
     @Retorno varchar(2000)

   --Saídas
   --Inconsistências na proposta
   if exists(Select top 1 'x' from consulta_itens where nm_fantasia_produto = @nm_fantasia_produto
             and cd_produto = @cd_produto and IsNull(ic_produto_especial,'N') = 'N')
      set @Retorno = 'Produto, já possui propostas comerciais com o fantasia anterior.'
   else --Inconsistências no pedido de venda
   if exists(Select top 1 'x' from pedido_venda_item where nm_fantasia_produto = @nm_fantasia_produto
             and cd_produto = @cd_produto and IsNull(ic_produto_especial,'N') = 'N')
      set @Retorno = 'Produto, já possui pedidos de venda com o fantasia anterior.'
   else --Inconsistências no faturamento
   if exists(Select top 1 'x' from nota_saida_item where nm_fantasia_produto = @nm_fantasia_produto
             and cd_produto = @cd_produto and IsNull(cd_produto,0) > 0 )
      set @Retorno = 'Produto, já possui nota fiscal com o fantasia anterior.'    
   --Entradas
   else --Inconsistências na cotação de compra
   if exists(Select top 1 'x' from cotacao_item where nm_produto_item_cotacao = @nm_fantasia_produto
             and cd_produto = @cd_produto and IsNull(cd_produto,0) > 0 )
      set @Retorno = 'Produto, já possui cotação com o fantasia anterior.'
   else --Inconsistências no pedidos de compra
   if exists(Select top 1 'x' from pedido_compra_item where nm_fantasia_produto = @nm_fantasia_produto
             and cd_produto = @cd_produto and IsNull(cd_produto,0) > 0 )
      set @Retorno = 'Produto, já possui pedido de compra com o fantasia anterior.'
   else --Inconsistências no recebimento
   if exists(Select top 1 'x' from nota_entrada_item where nm_produto_nota_entrada = @nm_fantasia_produto
             and cd_produto = @cd_produto and IsNull(cd_produto,0) > 0 )
      set @Retorno = 'Produto, já possui cotação com o fantasia anterior.'
   else    
      set @Retorno = ''   
   
  Select @Retorno as 'Resultado'

end

-- =============================================  
-- Testando a procedure  
-- ============================================= 

