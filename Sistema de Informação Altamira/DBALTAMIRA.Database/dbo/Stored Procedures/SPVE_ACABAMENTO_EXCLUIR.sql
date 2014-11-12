
/****** Object:  Stored Procedure dbo.SPVE_ACABAMENTO_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_ACABAMENTO_EXCLUIR    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE SPVE_ACABAMENTO_EXCLUIR

	@Codigo   tinyint

AS

BEGIN

	DELETE FROM VE_Acabamento
	      WHERE veac_Codigo = @Codigo

END


