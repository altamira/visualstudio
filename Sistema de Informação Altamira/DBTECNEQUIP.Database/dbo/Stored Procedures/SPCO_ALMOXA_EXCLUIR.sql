
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_EXCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_EXCLUIR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPCO_ALMOXA_EXCLUIR    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_ALMOXA_EXCLUIR

	@Codigo   char(9)

AS


BEGIN


	DELETE FROM CO_Almoxarifado
	      WHERE coal_Codigo = @Codigo


END


