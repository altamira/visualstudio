
/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_INCLUIR    Script Date: 25/08/1999 20:11:42 ******/
/****** Object:  Stored Procedure dbo.SPFF_CONTACORRENTE_INCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_CONTACORRENTE_INCLUIR

	@Banco          char(3),
	@Agencia        char(6),
	@Conta          char(10),
    @Gerente        varchar(30),
	@Telefone       char(10),
    @Previsao       char(1),
	@SaldoInicial       money,
    @DataSaldoInicial   smalldatetime
    
AS

BEGIN

	INSERT INTO FF_ContaCorrente (ffcc_Banco,
			               ffcc_Agencia,
				           ffcc_Conta,
						   ffcc_Gerente,
				           ffcc_Telefone,
                           ffcc_Previsao,
						   ffcc_SaldoInicial,
						   ffcc_DataSaldoInicial,
						   ffcc_DataSaldoAtual,
						   ffcc_DataSaldoConferido)
		      VALUES (@Banco,
			          @Agencia,
                      @Conta,
					  @Gerente,
			          @Telefone,
                      @Previsao,
					  @SaldoInicial,
					  @DataSaldoInicial,
					  @DataSaldoInicial,
					  @DataSaldoInicial)

END


