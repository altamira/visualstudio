
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_EXCLUIR    Script Date: 25/08/1999 20:11:22 ******/
CREATE PROCEDURE SPCO_FORNECEDOR_EXCLUIR

	@Codigo   char(14)

AS


BEGIN


	DELETE FROM CO_Fornecedor
	      WHERE cofc_Codigo = @Codigo


END


