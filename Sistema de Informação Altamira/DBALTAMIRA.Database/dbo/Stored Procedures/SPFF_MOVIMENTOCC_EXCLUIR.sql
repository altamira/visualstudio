
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_EXCLUIR    Script Date: 25/08/1999 20:11:25 ******/
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_EXCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_MOVIMENTOCC_EXCLUIR

	@Sequencia    int

AS

BEGIN

	DELETE FROM FF_MovimentoCC
	      WHERE ffmv_Sequencia = @Sequencia

END


