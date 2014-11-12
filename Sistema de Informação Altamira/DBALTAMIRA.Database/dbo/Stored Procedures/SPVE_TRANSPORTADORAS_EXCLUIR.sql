
/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_EXCLUIR    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_TRANSPORTADORAS_EXCLUIR

	@Codigo   int
AS

BEGIN

	DELETE FROM VE_Transportadoras
	      WHERE vetr_Codigo = @Codigo

END


