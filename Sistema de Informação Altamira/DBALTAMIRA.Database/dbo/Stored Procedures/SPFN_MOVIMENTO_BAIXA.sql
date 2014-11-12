
/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTO_BAIXA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTO_BAIXA    Script Date: 25/08/1999 20:11:51 ******/
CREATE PROCEDURE [dbo].[SPFN_MOVIMENTO_BAIXA]

	@DataFinal          smalldatetime,
	@Banco              char(3),
	@Agencia            char(10),
	@ContaCorrente      char(10)

AS

DECLARE @ValorInicial money
DECLARE @SaldoInicialConta money

BEGIN

    -- Abre Tansação
    BEGIN TRANSACTION

    -- Verifica se os movimentos deste periodo esta conferido
    IF EXISTS (SELECT 'X' 
                 FROM FN_MovimentoCC
                WHERE fnmv_Liquidado = '0'
                  AND fnmv_DataMovimento <= @DataFinal
                  AND fnmv_Banco         = @Banco
                  AND fnmv_Agencia       = @Agencia
                  AND fnmv_Conta         = @ContaCorrente)

        BEGIN

            -- Caso haja sem conferir retorna erro            
            RAISERROR ('Existem movimentos não conferidos!', 18, -1)

            -- Cancela Transacao
            ROLLBACK TRANSACTION

            RETURN

        END

    ELSE

        BEGIN
        
           -- Pega o saldo inicial da conta
           SELECT @SaldoInicialConta = fncc_SaldoInicial
            FROM FN_ContaCorrente
             WHERE fncc_Banco    = @Banco
               AND fncc_Agencia  = @Agencia
               AND fncc_Conta    = @ContaCorrente


           -- Caso esteja tudo conferido pega calculo do valor
           SELECT @ValorInicial = @SaldoInicialConta + Sum(fnmv_valor)
             FROM FN_MovimentoCC
            WHERE fnmv_DataMovimento <= @DataFinal
              AND fnmv_Banco         = @Banco
              AND fnmv_Agencia       = @Agencia
              AND fnmv_Conta         = @ContaCorrente

            
            -- Atualiza o valor na tabela de conta corrente
            UPDATE FN_ContaCorrente
               SET fncc_SaldoInicial     = @ValorInicial,
                   fncc_DataSaldoInicial = @DataFinal
             WHERE fncc_Banco            = @Banco
               AND fncc_Agencia          = @Agencia
               AND fncc_Conta            = @ContaCorrente

            
            -- Apaga os Movimento
            DELETE FROM FN_MovimentoCC
                  WHERE fnmv_DataMovimento <= @DataFinal
                    AND fnmv_Banco         = @Banco
                    AND fnmv_Agencia       = @Agencia
                    AND fnmv_Conta         = @ContaCorrente

        END

    -- Confirma Transação
    COMMIT TRANSACTION

END
	

