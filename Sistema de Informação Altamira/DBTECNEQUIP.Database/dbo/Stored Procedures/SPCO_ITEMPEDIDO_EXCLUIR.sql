
/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_EXCLUIR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_EXCLUIR    Script Date: 16/10/01 13:41:49 ******/
/****** Object:  Stored Procedure dbo.SPCO_ITEMPEDIDO_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE  SPCO_ITEMPEDIDO_EXCLUIR

   @Numero    int     -- Numero do pedido

AS

BEGIN

   DELETE FROM CO_ItemPedido 
         WHERE coit_Numero = @Numero


END


