
/****** Object:  Stored Procedure dbo.SPFF_SOCIOS_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_SOCIOS_INCLUIR    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFF_SOCIOS_INCLUIR

	@Codigo        char(1),
	@Nome          char(30)

AS

BEGIN

	INSERT INTO FI_Socios (fiso_Codigo,
			               fiso_Nome)
		      VALUES (@Codigo,
			          @Nome)

END

