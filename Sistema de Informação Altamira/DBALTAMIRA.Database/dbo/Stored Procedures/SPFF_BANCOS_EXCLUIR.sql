
/****** Object:  Stored Procedure dbo.SPFF_BANCOS_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_BANCOS_EXCLUIR    Script Date: 25/08/1999 20:11:34 ******/
/****** Object:  Stored Procedure dbo.SPFF_BANCOS_EXCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_BANCOS_EXCLUIR

	@Codigo   char(3)

AS

BEGIN

	DELETE FROM FF_Bancos
	      WHERE ffba_Codigo = @Codigo

END



