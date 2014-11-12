
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_RELATORIO    Script Date: 25/08/1999 20:11:50 ******/
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_RELATORIO    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_MOVIMENTOCC_RELATORIO

    @Banco          char(3),
    @Agencia        char(6),
    @Conta          char(10),
    @DataInicial    smalldatetime,
    @DataFinal      smalldatetime
AS


DECLARE @SaldoAteData    money,
        @Sequencia       int,
        @Valor           money,
        @ValorCorreto    money,
        @SaldoInicial    money

BEGIN

    -- Guarda o saldo inicial 
    SELECT @SaldoInicial = ISNULL(ffcc_SaldoInicial, 0)
      FROM FF_ContaCorrente
     WHERE ffcc_Banco   = @Banco
       AND ffcc_Agencia = @Agencia
       AND ffcc_Conta   = @Conta


    -- Faz a totalizacao do saldo ate a data pedida
    SELECT @SaldoInicial =  @SaldoInicial + ISNULL(SUM(ffmv_Valor), 0)
      FROM FF_MovimentoCC
     WHERE ffmv_Banco   = @Banco
       AND ffmv_Agencia = @Agencia
       AND ffmv_Conta   = @Conta
       AND ffmv_DataMovimento < @DataInicial   
    
    SELECT @SaldoAteData = @SaldoInicial

    -- Cria a tabela para guardar totais
    CREATE TABLE #LinhaTabela (Sequencia    int Null,
                               DataMovimento  smalldatetime Null,
                               NumeroCheque char(15) Null,
                               Liquidado    char(1) Null,
                               Descricao    varchar(50) Null,
                               Operacao     char(1) Null,
                               Valor        money Null,
                               SaldoAtual   money Null) 


            INSERT INTO #LinhaTabela(Sequencia,
                                     DataMovimento,
                                     NumeroCheque,
                                     Liquidado,
                                     Descricao,
                                     Operacao,
                                     Valor,
                                     SaldoAtual)

                             VALUES (NULL,
                                     DATEADD(Day, -1, @DataInicial),
                                     NULL,
                                     '1',
                                     'SALDO INICIAL',
                                     NULL,
                                     NULL,
                                     NULL)

    DECLARE curMovimento INSENSITIVE CURSOR
        FOR SELECT ffmv_Sequencia,
                   ffmv_Valor
              FROM FF_MovimentoCC
             WHERE ffmv_Banco   = @Banco
               AND ffmv_Agencia = @Agencia
               AND ffmv_Conta   = @Conta
               AND ffmv_DataMovimento Between @DataInicial And @DataFinal
          ORDER BY ffmv_DataMovimento

    OPEN curMovimento

    FETCH NEXT FROM curMovimento INTO
                    @Sequencia,
                    @Valor

    WHILE @@FETCH_STATUS = 0 

        BEGIN

            IF @Valor < 0 

                BEGIN

                    SELECT @ValorCorreto = @Valor * -1

                END

            ELSE

                BEGIN

                    SELECT @ValorCorreto = @Valor

                END

            
            -- Acumula o valor no saldo
            SELECT @SaldoAteData = @SaldoAteData + @Valor


            INSERT INTO #LinhaTabela(Sequencia,
                                     DataMovimento,
                                     NumeroCheque,
                                     Liquidado,
                                     Descricao,
                                     Operacao,
                                     Valor,
                                     SaldoAtual)
            

            SELECT ffmv_Sequencia,
                   ffmv_DataMovimento,
                   ffmv_NumeroCheque,
                   ffmv_Liquidado,
                   ffmv_Descricao,
                   ffmv_Operacao,
                   @ValorCorreto,
                   @SaldoAteData
              FROM FF_MovimentoCC
             WHERE ffmv_Sequencia = @Sequencia
             

            FETCH NEXT FROM curMovimento INTO
                            @Sequencia,
                            @Valor

        END

     CLOSE curMovimento
DEALLOCATE curMovimento

-- Grava data de impressao na conta-corrente

UPDATE FF_ContaCorrente 
   SET ffcc_DataRelatorio = @DataFinal
   WHERE ffcc_Banco = @Banco
     And ffcc_Agencia = @Agencia
     And ffcc_Conta = @Conta
     
-- Traz os dados 
SELECT *, @SaldoInicial 'SaldoInicial' FROM #LinhaTabela ORDER BY DataMovimento

END

