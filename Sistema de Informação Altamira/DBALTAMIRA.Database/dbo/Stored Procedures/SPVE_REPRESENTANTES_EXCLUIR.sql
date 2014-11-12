
/****** Object:  Stored Procedure dbo.SPVE_REPRESENTANTES_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_REPRESENTANTES_EXCLUIR    Script Date: 25/08/1999 20:11:28 ******/
CREATE PROCEDURE SPVE_REPRESENTANTES_EXCLUIR

	@Codigo   char(3)

AS

BEGIN

	DELETE FROM VE_Representantes
	      WHERE verp_Codigo = @Codigo

END


