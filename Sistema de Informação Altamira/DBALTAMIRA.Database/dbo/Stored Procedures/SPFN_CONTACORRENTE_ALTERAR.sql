
/****** Object:  Stored Procedure dbo.SPFN_CONTACORRENTE_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_CONTACORRENTE_ALTERAR    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE [dbo].[SPFN_CONTACORRENTE_ALTERAR]
	
	@Banco              char(3),
	@Agencia            char(10),
	@Conta              char(10),
    @Gerente            varchar(30),
	@Telefone           char(10),
    @Previsao           char(1),
	@SaldoInicial       money,
    @DataSaldoInicial   smalldatetime,
    @DataSaldoAtual     smalldatetime,
    @DataSaldoConferido smalldatetime

AS

BEGIN

	UPDATE FN_ContaCorrente
	   SET fncc_Gerente            = @Gerente,
	       fncc_Telefone           = @Telefone,
           fncc_Previsao           = @Previsao,
		   fncc_SaldoInicial       = @SaldoInicial,
		   fncc_DataSaldoInicial   = @DataSaldoInicial,
		   fncc_DataSaldoAtual     = @DataSaldoAtual,
		   fncc_DataSaldoConferido = @DataSaldoConferido 
	     WHERE fncc_banco = @Banco
		   And fncc_Agencia = @Agencia
		   And fncc_Conta = @Conta
END

