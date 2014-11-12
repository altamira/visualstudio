
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_EXCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_EXCLUIR    Script Date: 16/10/01 13:41:45 ******/
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCO_FORNECEDOR_EXCLUIR

	@Codigo   char(14)

AS


BEGIN


	DELETE FROM CO_Fornecedor
	      WHERE cofc_Codigo = @Codigo


END


