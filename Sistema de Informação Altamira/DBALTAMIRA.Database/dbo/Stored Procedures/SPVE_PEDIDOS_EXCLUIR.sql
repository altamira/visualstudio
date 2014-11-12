
/****** Object:  Stored Procedure dbo.SPVE_PEDIDOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_PEDIDOS_EXCLUIR    Script Date: 25/08/1999 20:11:28 ******/
CREATE PROCEDURE SPVE_PEDIDOS_EXCLUIR

	@Pedido  int
AS

BEGIN

	DELETE FROM VE_Pedidos
	      WHERE vepe_Pedido = @Pedido


END





