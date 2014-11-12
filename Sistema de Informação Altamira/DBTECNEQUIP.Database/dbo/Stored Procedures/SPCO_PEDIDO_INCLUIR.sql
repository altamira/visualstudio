﻿
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_INCLUIR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_INCLUIR    Script Date: 16/10/01 13:41:46 ******/
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_PEDIDO_INCLUIR

   @Numero        int,
   @Data          smalldatetime,
   @Fornecedor    char(14),
   @Condicoes     char(30),
   @TipoPreco     char(1),
   @Reajuste      char(10),
   @Imobilizado   char(9),
   @Observacao    varchar(100),
   @Status        char(1),  
   @TipoPedido    char(1),
   @ValorSubTotal money,
   @ValorIPIISS   money,
   @ValorTotal    money
   	
AS

BEGIN

	INSERT INTO CO_Pedido (cope_Numero,
     		               cope_Data,
				           cope_Fornecedor,
				           cope_Condicoes,
				           cope_TipoPreco,
				           cope_Reajuste,
				           cope_Imobilizado,
                           cope_Observacao,
                           cope_Status,
                           cope_TipoPedido,
                           cope_ValorSubTotal,
                           cope_ValorIPIISS,
                           cope_ValorTotal)
		
            VALUES (@Numero,
		            @Data,
			        @Fornecedor,
			        @Condicoes,
			        @TipoPreco,
			        @Reajuste,
                    @Imobilizado,
                    @Observacao,
                    ISNULL(@Status, ''),
                    @TipoPedido,
                    @ValorSubTotal,
                    @ValorIPIISS,
                    @ValorTotal)

END


