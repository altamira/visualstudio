
/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_EXCLUIR    Script Date: 25/08/1999 20:11:26 ******/
CREATE PROCEDURE SPFN_MOVIMENTOCC_EXCLUIR

	@Sequencia    int

AS

BEGIN

	DELETE FROM FN_MovimentoCC
	      WHERE fnmv_Sequencia = @Sequencia

END

