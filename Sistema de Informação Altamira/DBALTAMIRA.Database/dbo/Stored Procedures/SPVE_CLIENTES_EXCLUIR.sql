
/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_EXCLUIR    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE SPVE_CLIENTES_EXCLUIR

	@Codigo   char(14)

AS

BEGIN

	DELETE FROM VE_ClientesNovo
	      WHERE vecl_Codigo = @Codigo

END



