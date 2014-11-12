
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_EXCLUIR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_EXCLUIR    Script Date: 16/10/01 13:41:46 ******/
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_PEDIDO_EXCLUIR

	@Numero   int

AS

BEGIN

   DELETE FROM CO_Pedido
	      WHERE cope_Numero = @Numero

END



