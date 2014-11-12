
/****** Object:  Stored Procedure dbo.SPFF_SOCIOS_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_SOCIOS_EXCLUIR    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFF_SOCIOS_EXCLUIR

	@Codigo   char(3)

AS

BEGIN

	DELETE FROM FI_Socios
	      WHERE fiso_Codigo = @Codigo

END


