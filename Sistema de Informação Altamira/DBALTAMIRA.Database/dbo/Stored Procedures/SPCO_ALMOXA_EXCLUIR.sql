
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_EXCLUIR    Script Date: 25/08/1999 20:11:22 ******/
CREATE PROCEDURE SPCO_ALMOXA_EXCLUIR

	@Codigo   char(9)

AS


BEGIN


	DELETE FROM CO_Almoxarifado
	      WHERE coal_Codigo = @Codigo


END


