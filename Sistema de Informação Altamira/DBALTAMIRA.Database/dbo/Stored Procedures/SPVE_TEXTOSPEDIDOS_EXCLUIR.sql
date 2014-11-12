
/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_EXCLUIR    Script Date: 25/08/1999 20:11:29 ******/
CREATE PROCEDURE SPVE_TEXTOSPEDIDOS_EXCLUIR

	@Pedido   int,
    @Item     tinyint

AS

BEGIN

	DELETE FROM VE_TextosPedidos
	      WHERE vetx_Pedido = @Pedido
            AND vetx_Item = @Item

END


