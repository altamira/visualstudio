
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOS_EXCLUIR    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE SPFF_MOVIMENTOS_EXCLUIR

	@Sequencia    int

AS

BEGIN

	DELETE FROM FI_Movimentos
	      WHERE fimo_Sequencia = @Sequencia

END

