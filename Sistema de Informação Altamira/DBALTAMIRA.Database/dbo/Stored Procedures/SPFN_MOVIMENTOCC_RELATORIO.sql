
/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_RELATORIO    Script Date: 25/08/1999 20:11:51 ******/
CREATE PROCEDURE [dbo].[SPFN_MOVIMENTOCC_RELATORIO]

    @Banco          char(3),
    @Agencia        char(10),
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
    SELECT @SaldoInicial = ISNULL(fncc_SaldoInicial, 0)
      FROM FN_ContaCorrente
     WHERE fncc_Banco   = @Banco
       AND fncc_Agencia = @Agencia
       AND fncc_Conta   = @Conta


    -- Faz a totalizacao do saldo ate a data pedida
    SELECT @SaldoInicial =  @SaldoInicial + ISNULL(SUM(fnmv_Valor), 0)
      FROM FN_MovimentoCC
     WHERE fnmv_Banco   = @Banco
       AND fnmv_Agencia = @Agencia
       AND fnmv_Conta   = @Conta
       AND fnmv_DataMovimento < @DataInicial   
    
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
        FOR SELECT fnmv_Sequencia,
                   fnmv_Valor
              FROM FN_MovimentoCC
             WHERE fnmv_Banco   = @Banco
               AND fnmv_Agencia = @Agencia
               AND fnmv_Conta   = @Conta
               AND fnmv_DataMovimento Between @DataInicial And @DataFinal
          ORDER BY fnmv_DataMovimento

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
            

            SELECT fnmv_Sequencia,
                   fnmv_DataMovimento,
                   fnmv_NumeroCheque,
                   fnmv_Liquidado,
                   fnmv_Descricao,
                   fnmv_Operacao,
                   @ValorCorreto,
                   @SaldoAteData
              FROM FN_MovimentoCC
             WHERE fnmv_Sequencia = @Sequencia
             

            FETCH NEXT FROM curMovimento INTO
                            @Sequencia,
                            @Valor

        END

     CLOSE curMovimento
DEALLOCATE curMovimento

-- Grava data de impressao na conta-corrente

UPDATE FN_ContaCorrente 
   SET fncc_DataRelatorio = @DataFinal
   WHERE fncc_Banco = @Banco
     And fncc_Agencia = @Agencia
     And fncc_Conta = @Conta
     
-- Traz os dados 
SELECT *, @SaldoInicial 'SaldoInicial' FROM #LinhaTabela ORDER BY DataMovimento

END

