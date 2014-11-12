
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_ALTERAR    Script Date: 25/08/1999 20:11:50 ******/
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_ALTERAR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_MOVIMENTOCC_ALTERAR

	@Sequencia	    int,
	@Banco		    char(3),
	@Agencia	    char(6),
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


	UPDATE FF_MovimentoCC
	 
	   SET ffmv_Banco         = @Banco,
		   ffmv_Agencia       = @Agencia,
		   ffmv_Conta         = @Conta,
		   ffmv_DataMovimento = @DataMovimento,
		   ffmv_NumeroCheque  = @NumeroCheque,
		   ffmv_Liquidado     = @Liquidado,
		   ffmv_Descricao     = @Descricao,
		   ffmv_Valor         = @Valor,
		   ffmv_Operacao      = @Operacao,
		   ffmv_Investimento  = @Investimento
	 
	 WHERE ffmv_Sequencia = @Sequencia

	-- Atualiza a tabela de contas
	UPDATE FF_ContaCorrente
	   SET ffcc_DataSaldoAtual = GETDATE()
	 WHERE ffcc_Banco   = @Banco
	   AND ffcc_Agencia = @Agencia
	   AND ffcc_Conta   = @Conta

END


