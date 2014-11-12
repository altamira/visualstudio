
/****** Object:  Stored Procedure dbo.SPCO_PASTA_EXCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_PASTA_EXCLUIR    Script Date: 16/10/01 13:41:40 ******/
/****** Object:  Stored Procedure dbo.SPCO_PASTA_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_PASTA_EXCLUIR

	@Codigo   tinyint

AS


BEGIN


	DELETE FROM CO_Pasta
	      WHERE copt_Codigo = @Codigo


END


