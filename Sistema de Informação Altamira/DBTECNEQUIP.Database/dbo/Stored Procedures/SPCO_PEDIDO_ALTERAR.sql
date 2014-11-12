
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_ALTERAR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_ALTERAR    Script Date: 16/10/01 13:41:46 ******/
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_ALTERAR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_PEDIDO_ALTERAR
	
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


	UPDATE CO_Pedido
      SET cope_Data           = @Data,
          cope_Fornecedor     = @Fornecedor,
          cope_Condicoes      = @Condicoes,
          cope_TipoPreco      = @TipoPreco,
          cope_Reajuste       = @Reajuste,
          cope_Imobilizado    = @Imobilizado,
	      cope_Observacao     = @observacao,
          cope_Status         = ISNULL(@Status, ''),
          cope_TipoPedido     = @TipoPedido,
          cope_ValorSubTotal  = @ValorSubTotal,
          cope_ValorIPIISS    = @ValorIPIISS,
          cope_ValorTotal     = @ValorTotal
    WHERE cope_Numero         = @Numero

END



