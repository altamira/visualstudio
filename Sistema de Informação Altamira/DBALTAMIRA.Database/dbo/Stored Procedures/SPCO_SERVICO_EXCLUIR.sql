
/****** Object:  Stored Procedure dbo.SPCO_SERVICO_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCO_SERVICO_EXCLUIR    Script Date: 25/08/1999 20:11:31 ******/
CREATE PROCEDURE SPCO_SERVICO_EXCLUIR

	@Codigo   tinyint

AS


BEGIN


	DELETE FROM CO_Servico
	      WHERE cose_Codigo = @Codigo


END


