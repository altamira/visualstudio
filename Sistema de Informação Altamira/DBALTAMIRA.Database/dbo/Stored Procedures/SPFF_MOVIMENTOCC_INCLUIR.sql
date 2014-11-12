
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_INCLUIR    Script Date: 25/08/1999 20:11:50 ******/
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_INCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_MOVIMENTOCC_INCLUIR

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

	-- Inclui na tabela de movimentos de CC
	INSERT INTO FF_MovimentoCC (ffmv_Banco,
								ffmv_Agencia,
								ffmv_Conta,
								ffmv_DataMovimento,
								ffmv_NumeroCheque,
								ffmv_Liquidado,
								ffmv_Descricao,
								ffmv_Valor,
								ffmv_Operacao,
								ffmv_Investimento)
						
						VALUES (@Banco,
								@Agencia,
								@Conta,
								@DataMovimento,
								@NumeroCheque,
								@Liquidado,
								@Descricao,
								@Valor,
								@Operacao,
								@Investimento)

                    -- Atualiza a data do saldo da conta corrente
					UPDATE FF_ContaCorrente 
					   SET ffcc_DataSaldoAtual = GETDATE()
					 
					 WHERE ffcc_Banco   = @Banco
					   AND ffcc_Agencia = @Agencia
					   AND ffcc_Conta   = @Conta

END


