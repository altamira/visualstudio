
/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_EXCLUIR    Script Date: 25/08/1999 20:11:52 ******/
CREATE PROCEDURE  SPCO_ITEMPEDIDO_EXCLUIR

   @Numero    int     -- Numero do pedido

AS

BEGIN

   DELETE FROM CO_ItemPedido 
         WHERE coit_Numero = @Numero


END


