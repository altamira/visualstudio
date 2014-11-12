
/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/
CREATE PROCEDURE [dbo].[SPFN_MOVIMENTOCC_INCLUIR]

	@Banco		    char(3),
	@Agencia	    char(10),
	@Conta		    char(10),
	@DataMovimento	smalldatetime,
	@NumeroCheque   char(15) = NULL,--ocorreu um erro apos ter gerado o script
	@Liquidado      char(1),
	@Descricao      varchar(50),
	@Valor			money,
	@Operacao		char(1),
	@Investimento	char(1)

AS

BEGIN

	-- Inclui na tabela de movimentos de CC
	INSERT INTO FN_MovimentoCC (fnmv_Banco,
								fnmv_Agencia,
								fnmv_Conta,
								fnmv_DataMovimento,
								fnmv_NumeroCheque,
								fnmv_Liquidado,
								fnmv_Descricao,
								fnmv_Valor,
								fnmv_Operacao,
								fnmv_Investimento)
						
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
					UPDATE FN_ContaCorrente 
					   SET fncc_DataSaldoAtual = GETDATE()
					 
					 WHERE fncc_Banco   = @Banco
					   AND fncc_Agencia = @Agencia
					   AND fncc_Conta   = @Conta

END

