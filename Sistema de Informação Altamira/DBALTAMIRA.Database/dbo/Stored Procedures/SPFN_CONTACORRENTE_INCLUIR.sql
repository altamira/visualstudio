
/****** Object:  Stored Procedure dbo.SPFN_CONTACORRENTE_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_CONTACORRENTE_INCLUIR    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE [dbo].[SPFN_CONTACORRENTE_INCLUIR]

	@Banco          char(3),
	@Agencia        char(10),
	@Conta          char(10),
    @Gerente        varchar(30),
	@Telefone       char(10),
    @Previsao       char(1),
	@SaldoInicial       money,
    @DataSaldoInicial   smalldatetime
    
AS

BEGIN

	INSERT INTO FN_ContaCorrente (fncc_Banco,
			               fncc_Agencia,
				           fncc_Conta,
						   fncc_Gerente,
				           fncc_Telefone,
                           fncc_Previsao,
						   fncc_SaldoInicial,
						   fncc_DataSaldoInicial,
						   fncc_DataSaldoAtual,
						   fncc_DataSaldoConferido)
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

