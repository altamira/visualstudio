
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_EXCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPFN_BANCOS_EXCLUIR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPFN_BANCOS_EXCLUIR    Script Date: 13/08/1998 09:19:08 ******/
CREATE PROCEDURE SPFN_BANCOS_EXCLUIR

	@Codigo   char(3)

AS

BEGIN

	DELETE FROM FN_Bancos
	      WHERE fnba_Codigo = @Codigo

END


