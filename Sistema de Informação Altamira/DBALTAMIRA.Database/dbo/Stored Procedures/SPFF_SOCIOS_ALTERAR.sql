
/****** Object:  Stored Procedure dbo.SPFF_SOCIOS_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_SOCIOS_ALTERAR    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFF_SOCIOS_ALTERAR
	
	@Codigo    char(1),
	@Nome      char(30)

AS

BEGIN

	UPDATE FI_Socios
	   SET fiso_Nome = @Nome
	      WHERE fiso_Codigo = @Codigo

END

