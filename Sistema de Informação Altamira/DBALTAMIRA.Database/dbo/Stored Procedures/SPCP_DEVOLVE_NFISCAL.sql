
/****** Object:  Stored Procedure dbo.SPCP_DEVOLVE_NFISCAL    Script Date: 23/10/2010 13:58:21 ******/

/****** Object:  Stored Procedure dbo.SPCP_DEVOLVE_NFISCAL    Script Date: 11/10/1999 13:25:57 ******/
CREATE PROCEDURE [dbo].[SPCP_DEVOLVE_NFISCAL]

   @NumeroPedido    int,           -- Número do pedido
   @NumeroNota      char(6),       -- Numero da nota fiscal
   @NumeroItem      tinyint       

AS

DECLARE @CodigoCredito     char(1), 
	    @CodigoFornecedor  char(14),
	    @TipoPedido        char(1),
	    @CodigoProduto   char(9),   
	    @Quantidade      float         

BEGIN

   SELECT 	@CodigoFornecedor 	= cope_Fornecedor, 
                	@TipoPedido 		= cope_TipoPedido
           FROM CO_Pedido
            WHERE cope_Numero = @NumeroPedido

     SELECT DISTINCT 
        @CodigoProduto = coit_produto,
        @Quantidade    = coit_Quantidade
     FROM CO_ItemPedido
     WHERE 	coit_numero 	= @NumeroPedido AND 
           		coit_item   	= @NumeroItem 
   
   -- Exclui a nota   
     IF @TipoPedido = 'P'
     BEGIN
          DELETE from CP_NotaFiscal
	  where   cpnf_Pedido 		= @NumeroPedido And
		  cpnf_NotaFiscal	= @NumeroNota
     END
   -- Exclui Item da Nota
     DELETE from CO_ItemNota
	  where 	coin_Numero 	= @NumeroPedido And
	       	coin_Nota	= @NumeroNota And
                	coin_item       	= @NumeroItem
	
          DELETE from CP_NotaFiscalDetalhe
	  where   cpnd_Pedido 		= @NumeroPedido And
		  cpnd_NotaFiscal	= @NumeroNota
	
     IF SUBSTRING(@CodigoProduto, 4, 6) <> '000000' 

     BEGIN
      -- Atualiza o preco do produto na tabela almoxarifado
   
        UPDATE CO_Almoxarifado
           SET	coal_Saldo	= coal_Saldo - @Quantidade
        WHERE	coal_Codigo 	= @CodigoProduto 

        IF SUBSTRING(@CodigoProduto, 1, 3) = 'WBO'

        BEGIN
      
      -- Deleta na tabela de historico de bobinas

           DELETE from CO_HistoricoBobina
	  where	  cohb_Nota	= @NumeroNota And
		  cohb_Pedido	= @NumeroPedido And
		  cohb_Codigo 	= @CodigoProduto
        END

        IF SUBSTRING(@CodigoProduto, 1, 3) = 'WCB'

        BEGIN
      
          -- deletar na tabela de historico de Chapas
          DELETE CO_HistoricoChapa 
	  where   cohc_Nota 	= @NumeroNota And
		  cohc_Pedido	= @NumeroPedido And
		  cohc_Codigo 	= @CodigoProduto
        END
     END

END








