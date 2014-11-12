
/****** Object:  Stored Procedure dbo.SPFN_CONTACORRENTE_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_CONTACORRENTE_EXCLUIR    Script Date: 25/08/1999 20:11:26 ******/
CREATE PROCEDURE [dbo].[SPFN_CONTACORRENTE_EXCLUIR]

	@Banco     char(3),
	@Agencia   char(10),
	@Conta     char(10)

AS

BEGIN

	DELETE FROM FN_ContaCorrente
	      WHERE fncc_Banco = @Banco
		    And fncc_Agencia = @Agencia
			And fncc_Conta = @Conta

END


