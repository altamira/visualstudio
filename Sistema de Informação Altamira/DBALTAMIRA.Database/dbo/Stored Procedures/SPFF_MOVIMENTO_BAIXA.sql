
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTO_BAIXA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTO_BAIXA    Script Date: 25/08/1999 20:11:50 ******/
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTO_BAIXA    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_MOVIMENTO_BAIXA

	@DataFinal          smalldatetime,
	@Banco              char(3),
	@Agencia            char(6),
	@ContaCorrente      char(10)

AS

DECLARE @ValorInicial money


BEGIN

    -- Abre Tansação
    BEGIN TRANSACTION

    -- Verifica se os movimentos deste periodo esta conferido
    IF EXISTS (SELECT 'X' 
                 FROM FF_MovimentoCC
                WHERE ffmv_Liquidado =  '0'
                  AND ffmv_DataMovimento <= @DataFinal
                  AND ffmv_Banco         = @Banco
                  AND ffmv_Agencia       = @Agencia
                  AND ffmv_Conta         = @ContaCorrente)

        BEGIN

            -- Caso haja sem conferir retorna erro            
            RAISERROR ('Existem movimentos não conferidos!', 18, -1)

            -- Cancela Transacao
            ROLLBACK TRANSACTION

            RETURN

        END

    ELSE

        BEGIN
        
           -- Caso esteja tudo conferido pega calculo do valor
           SELECT @ValorInicial = Sum(ffmv_valor)
             FROM FF_MovimentoCC
            WHERE ffmv_DataMovimento <= @DataFinal
              AND ffmv_Banco         = @Banco
              AND ffmv_Agencia       = @Agencia
              AND ffmv_Conta         = @ContaCorrente

            
            -- Atualiza o valor na tabela de conta corrente
            UPDATE FF_ContaCorrente
               SET ffcc_SaldoInicial     = @ValorInicial,
                   ffcc_DataSaldoInicial = @DataFinal
             WHERE ffcc_Banco            = @Banco
               AND ffcc_Agencia          = @Agencia
               AND ffcc_Conta            = @ContaCorrente

            
            -- Apaga os Movimento
            DELETE FROM FF_MovimentoCC
                  WHERE ffmv_DataMovimento <= @DataFinal
                    AND ffmv_Banco         = @Banco
                    AND ffmv_Agencia       = @Agencia
                    AND ffmv_Conta         = @ContaCorrente

        END

    -- Confirma Transação
    COMMIT TRANSACTION

END
	


