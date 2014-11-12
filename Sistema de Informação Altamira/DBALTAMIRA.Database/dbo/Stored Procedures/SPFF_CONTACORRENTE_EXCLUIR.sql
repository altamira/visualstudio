
/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_EXCLUIR    Script Date: 25/08/1999 20:11:25 ******/
/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_EXCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_CONTACORRENTE_EXCLUIR

	@Banco     char(3),
	@Agencia   char(6),
	@Conta     char(10)

AS

BEGIN

	DELETE FROM FF_ContaCorrente
	      WHERE ffcc_Banco = @Banco
		    And ffcc_Agencia = @Agencia
			And ffcc_Conta = @Conta

END



