
/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_ATUALIZA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_MOVIMENTOCC_ATUALIZA    Script Date: 25/08/1999 20:11:51 ******/
CREATE PROCEDURE [dbo].[SPFN_MOVIMENTOCC_ATUALIZA]

    @Banco          char(3),
    @Agencia        char(10),
    @Conta          char(10)
    
AS

DECLARE @SaldoAteData    money,
        @Sequencia       int,
        @Valor           money,
        @ValorCorreto    money,
        @SaldoInicial    money,
        @DataInicial     smalldatetime,
        @Liquidado       char(1)

BEGIN

    -- Cria a tabela para guardar totais
    CREATE TABLE #LinhaTabela (Sequencia    int Null,
                               DataMovimento  smalldatetime Null,
                               NumeroCheque char(15) Null,
                               Liquidado    char(1) Null ,
                               Descricao    varchar(50) Null,
                               Operacao     char(1) Null,
                               Valor        money Null,
                               SaldoAtual   money Null) 


    -- Declara o cursor
    DECLARE CUR_Movimentos Insensitive Cursor
    For Select fnmv_DataMovimento, 
               fnmv_Liquidado
          From FN_MovimentoCC
          Where fnmv_Banco = @Banco
            And fnmv_Agencia = @Agencia
            And fnmv_Conta = @Conta
          Order By fnmv_DataMovimento,fnmv_Sequencia
      
    Open CUR_Movimentos

    Fetch Next From CUR_Movimentos Into @DataInicial, @Liquidado
              
    
    While @@Fetch_Status = 0
      Begin
        If @Liquidado = '0' 
           Begin
              Break 
           End

    Fetch Next From CUR_Movimentos Into @DataInicial, @Liquidado

    End   
   
   
     Close CUR_Movimentos
DeAllocate CUR_Movimentos


    IF @Liquidado = '1' 

       BEGIN

         SELECT @DataInicial = '31/12/2050'

         INSERT INTO #LinhaTabela(Sequencia,
                                  DataMovimento,
                                  NumeroCheque,
                                  Liquidado,
                                  Descricao,
                                  Operacao,
                                  Valor,
                                  SaldoAtual)
             VALUES (Null,
                     Null,
                     Null,
                     '0',
                     Null,
                     Null,
                     Null,
                     Null)

       END
    
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


    DECLARE curMovimento INSENSITIVE CURSOR
        FOR SELECT fnmv_Sequencia,
                   fnmv_Valor
              FROM FN_MovimentoCC
             WHERE fnmv_Banco   = @Banco
               AND fnmv_Agencia = @Agencia
               AND fnmv_Conta   = @Conta
               AND fnmv_DataMovimento >= @DataInicial
            ORDER BY fnmv_DataMovimento,fnmv_Sequencia

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


-- Traz os dados 
SELECT *, @SaldoInicial 'SaldoInicial' FROM #LinhaTabela ORDER BY DataMovimento, Sequencia

END






