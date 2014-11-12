
/****** Object:  Stored Procedure dbo.SPCO_PASTA_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCO_PASTA_ALTERAR    Script Date: 25/08/1999 20:11:31 ******/
CREATE PROCEDURE SPCO_PASTA_ALTERAR
	
	@Codigo    tinyint,
	@Descricao char(40)

AS


BEGIN


	UPDATE CO_Pasta
	   SET copt_Descricao = @Descricao
         WHERE copt_Codigo = @Codigo


END


