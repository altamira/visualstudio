
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_EXCLUIR    Script Date: 25/08/1999 20:11:47 ******/
CREATE PROCEDURE SPCO_PEDIDO_EXCLUIR

	@Numero   int

AS

BEGIN

  INSERT INTO SI_HISTORICO (SIHI_MODULO,SIHI_SISTEMA,SIHI_CAMPO,SIHI_VALORANTES,SIHI_VALORDEPOIS,SIHI_USUARIO,SIHI_DATA)
		VALUES (
		'Manutenção de Pedidos','COMPRAS','Cancelamento de Pedido',@Numero,0,'Compras',getdate())

   DELETE FROM CO_Pedido
	      WHERE cope_Numero = @Numero

END




