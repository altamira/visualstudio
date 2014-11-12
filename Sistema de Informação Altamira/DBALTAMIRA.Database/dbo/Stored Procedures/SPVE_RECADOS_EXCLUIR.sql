
/****** Object:  Stored Procedure dbo.SPVE_RECADOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOS_EXCLUIR    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPVE_RECADOS_EXCLUIR

	@Numero  int
AS

BEGIN

	DELETE FROM VE_Recados
	      WHERE vere_Numero = @Numero

END


