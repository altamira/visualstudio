
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFN_BANCOS_EXCLUIR    Script Date: 25/08/1999 20:11:25 ******/
CREATE PROCEDURE SPFN_BANCOS_EXCLUIR

	@Codigo   char(3)

AS

BEGIN

	DELETE FROM FN_Bancos
	      WHERE fnba_Codigo = @Codigo

END


