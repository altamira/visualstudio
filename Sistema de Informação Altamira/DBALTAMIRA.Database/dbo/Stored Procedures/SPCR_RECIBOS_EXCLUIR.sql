
/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCR_RECIBOS_EXCLUIR    Script Date: 25/08/1999 20:11:25 ******/
CREATE PROCEDURE SPCR_RECIBOS_EXCLUIR

	@Numero   int

AS


BEGIN


	DELETE FROM CR_Recibos
	      WHERE crre_Numero = @Numero


END


