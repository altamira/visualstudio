
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_ATUALIZA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_ATUALIZA    Script Date: 25/08/1999 20:11:50 ******/
/****** Object:  Stored Procedure dbo.SPFF_MOVIMENTOCC_ATUALIZA    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_MOVIMENTOCC_ATUALIZA

    @Banco          char(3),
    @Agencia        char(6),
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
                               Liquidado    char(1) Null,
                               Descricao    varchar(50) Null,
                               Operacao     char(1) Null,
                               Valor        money Null,
                               SaldoAtual   money Null) 


    -- Declara o cursor
    DECLARE CUR_Movimentos Insensitive Cursor
    For Select ffmv_DataMovimento, 
               ffmv_Liquidado
          From FF_MovimentoCC
          Where ffmv_Banco = @Banco
            And ffmv_Agencia = @Agencia
            And ffmv_Conta = @Conta
          Order By ffmv_DataMovimento
      
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

         SELECT @DataInicial = '12/31/2050'

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


    DECLARE curMovimento INSENSITIVE CURSOR
        FOR SELECT ffmv_Sequencia,
                   ffmv_Valor
              FROM FF_MovimentoCC

             WHERE ffmv_Banco   = @Banco
               AND ffmv_Agencia = @Agencia
               AND ffmv_Conta   = @Conta
               AND ffmv_DataMovimento >= @DataInicial
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


-- Traz os dados 
SELECT *, @SaldoInicial 'SaldoInicial' FROM #LinhaTabela ORDER BY DataMovimento

END


