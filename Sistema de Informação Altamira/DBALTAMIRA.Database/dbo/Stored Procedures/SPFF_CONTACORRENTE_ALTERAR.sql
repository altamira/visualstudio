
/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_ALTERAR    Script Date: 25/08/1999 20:11:42 ******/
/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_ALTERAR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_CONTACORRENTE_ALTERAR
	
	@Banco              char(3),
	@Agencia            char(6),
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

	UPDATE FF_ContaCorrente
	   SET ffcc_Gerente            = @Gerente,
	       ffcc_Telefone           = @Telefone,
           ffcc_Previsao           = @Previsao,
		   ffcc_SaldoInicial       = @SaldoInicial,
		   ffcc_DataSaldoInicial   = @DataSaldoInicial,
		   ffcc_DataSaldoAtual     = @DataSaldoAtual,
		   ffcc_DataSaldoConferido = @DataSaldoConferido 
	     WHERE ffcc_banco = @Banco
		   And ffcc_Agencia = @Agencia
		   And ffcc_Conta = @Conta
END


