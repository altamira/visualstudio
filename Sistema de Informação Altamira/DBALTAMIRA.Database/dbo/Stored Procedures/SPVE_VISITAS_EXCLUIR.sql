
/****** Object:  Stored Procedure dbo.SPVE_VISITAS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_VISITAS_EXCLUIR    Script Date: 25/08/1999 20:11:29 ******/
CREATE PROCEDURE SPVE_VISITAS_EXCLUIR

	@Numero Int
AS

BEGIN

	DELETE FROM VE_Visitas
	      WHERE vevi_Numero = @Numero

END



