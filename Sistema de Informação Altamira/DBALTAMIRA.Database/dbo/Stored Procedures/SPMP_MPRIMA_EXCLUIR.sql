
/****** Object:  Stored Procedure dbo.SPMP_MPRIMA_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE  SPMP_MPRIMA_EXCLUIR 
	@Codigo Char(16)
AS
BEGIN
	DELETE FROM PR_MPrima
	      WHERE prmp_Codigo = @Codigo
END

