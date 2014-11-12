
/****** Object:  Stored Procedure dbo.SPPR_ORCAMENTOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPPR_ORCAMENTOS_EXCLUIR    Script Date: 25/08/1999 20:11:26 ******/
CREATE PROCEDURE SPPR_ORCAMENTOS_EXCLUIR

	@Numero        int
AS

BEGIN

	DELETE FROM PRE_Orcamentos
	      WHERE pror_Numero = @Numero

END



