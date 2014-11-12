
/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_ALTERAR    Script Date: 25/08/1999 20:11:51 ******/
CREATE PROCEDURE [dbo].[SPFN_MOVIMENTOCC_ALTERAR]

	@Sequencia	    int,
	@Banco		    char(3),
	@Agencia	    char(10),
	@Conta		    char(10),
	@DataMovimento	smalldatetime,
	@NumeroCheque   char(15),
	@Liquidado      char(1),
	@Descricao      varchar(50),
	@Valor			money,
	@Operacao		char(1),
	@Investimento	char(1)


AS
	

BEGIN


	UPDATE FN_MovimentoCC
	 
	   SET fnmv_Banco         = @Banco,
		   fnmv_Agencia       = @Agencia,
		   fnmv_Conta         = @Conta,
		   fnmv_DataMovimento = @DataMovimento,
		   fnmv_NumeroCheque  = @NumeroCheque,
		   fnmv_Liquidado     = @Liquidado,
		   fnmv_Descricao     = @Descricao,
		   fnmv_Valor         = @Valor,
		   fnmv_Operacao      = @Operacao,
		   fnmv_Investimento  = @Investimento
	 
	 WHERE fnmv_Sequencia = @Sequencia

	-- Atualiza a tabela de contas
	UPDATE FN_ContaCorrente
	   SET fncc_DataSaldoAtual = GETDATE()
	 WHERE fncc_Banco   = @Banco
	   AND fncc_Agencia = @Agencia
	   AND fncc_Conta   = @Conta

END

