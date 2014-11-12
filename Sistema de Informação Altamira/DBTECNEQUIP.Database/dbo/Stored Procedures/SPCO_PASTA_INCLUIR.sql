
/****** Object:  Stored Procedure dbo.SPCO_PASTA_INCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_PASTA_INCLUIR    Script Date: 16/10/01 13:41:40 ******/
/****** Object:  Stored Procedure dbo.SPCO_PASTA_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_PASTA_INCLUIR

	@Codigo    tinyint,
	@Descricao char(40)

AS

BEGIN

	INSERT INTO CO_Pasta (copt_Codigo,
			      copt_Descricao)

		      VALUES (@Codigo,
			      @Descricao)

END

