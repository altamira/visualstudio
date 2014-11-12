
/****** Object:  Stored Procedure dbo.SPFF_CALCPREVISAO_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_CALCPREVISAO_RELATORIO    Script Date: 25/08/1999 20:11:42 ******/
/****** Object:  Stored Procedure dbo.SPFF_CALCPREVISAO_RELATORIO    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_CALCPREVISAO_RELATORIO

@DataInicial     smalldatetime,
@DataFinal       smalldatetime

AS

DECLARE @DataAtual   smalldatetime,
        @TotalInicialBanco  money,
        @TotalBanco           money,
        @TotalCredito         money,
        @TotalDebito          money,
        @TotalGeralDespesa    money,
        @TotalGeral           money,
        @TotalPessoal         money

BEGIN

    CREATE TABLE #CalculoPrevisao (Titulo  varchar(15)   Null,
                                   Descricao varchar(30) Null,
                                   Agencia char(6) Null,
                                   Conta char(10) Null,
                                   Valor money Null,
                                   Data smalldatetime Null,
                                   Linha varchar(200) null,
                                   Auxiliar char(15) Null,
                                   AuxiliarValor money Null)

                CREATE INDEX IDX_Data 
                ON #CalculoPrevisao(Data)


  -- Insere Titulo
  INSERT INTO #CalculoPrevisao (Titulo) Values ('SALDOS')


  -- PRIMEIRO BANCO

  INSERT INTO #CalculoPrevisao (Descricao,
                                Agencia,
                                Conta,
                                Valor,
                                Data)

  SELECT ffba_NomeBanco, 
       ffcc_Agencia, 
       ffcc_Conta,
       ISNULL(SUM(ffmv_Valor), 0) + ffcc_SaldoInicial Saldo,
       @DataInicial

  FROM FF_MovimentoCC LEFT JOIN FF_CONTACORRENTE ON ffmv_Banco = ffcc_Banco
   AND ffmv_Agencia = ffcc_Agencia
   AND ffmv_Conta = ffcc_Conta,
       FF_Bancos

 WHERE ffcc_Previsao = '1'
   AND ffba_Codigo = ffcc_Banco

GROUP BY ffba_NomeBanco,
         ffcc_Agencia,
         ffcc_Conta,
         ffcc_SaldoInicial

ORDER BY ffba_NomeBanco





-- GUARDA O SALDO TOTAL DE BANCOS
  SELECT  @TotalBanco = ISNULL(SUM(Valor), 0) 
  FROM #CalculoPrevisao

-- Insere Total
INSERT INTO #CalculoPrevisao (Auxiliar,
                              AuxiliarValor,
                              Data)

SELECT 'Total',  @TotalBanco, @DataInicial




-- Insere linha em branco
INSERT INTO #CalculoPrevisao (Titulo) Values ('')


-- Define a primeira data
SELECT @DataAtual = @DataInicial


WHILE @DataAtual <= @DataFinal



    BEGIN



    -- Insere Titulo
    INSERT INTO #CalculoPrevisao (Titulo) Values ('CRÉDITOS')

    
      -- FAZ CREDITO
    INSERT INTO #CalculoPrevisao (Descricao,
                                 Valor,
                                 Data)
    SELECT ffpr_Descricao,
           ffpr_Valor,
           @DataAtual
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'C' 
       AND ffpr_Data = @DataAtual


    -- Insere Total credito
    INSERT INTO #CalculoPrevisao (Auxiliar,
                                  AuxiliarValor,
                                  Data)
      SELECT 'Total', 
             ISNULL(SUM(ffpr_Valor), 0), 
             @DataAtual
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'C' 
       AND ffpr_Data = @DataAtual


    -- GUARDA O TOTAL DE CREDITO
      SELECT @TotalCredito = ISNULL(SUM(ffpr_Valor), 0) 
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'C' 
       AND ffpr_Data = @DataAtual



    -- Insere linha em branco
    INSERT INTO #CalculoPrevisao (Titulo) Values ('')
   
   
    -- Insere Titulo
   INSERT INTO #CalculoPrevisao (Titulo) Values ('DÉBITOS')

     -- FAZ DEBITO
   INSERT INTO #CalculoPrevisao (Descricao,
                                 Valor,
                                 Data)
    SELECT ffpr_Descricao,
           ffpr_Valor,
           @DataAtual
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'D' 
       AND ffpr_Data = @DataAtual


    -- Insere Total Debito
    INSERT INTO #CalculoPrevisao (Auxiliar,
                                  AuxiliarValor,
                                  Data)
      SELECT 'Total', 
             ISNULL(SUM(ffpr_Valor), 0), 
             @DataAtual
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'D' 
       AND ffpr_Data = @DataAtual

    -- GUARDA O TOTAL DE DEBITO
      SELECT @TotalDebito = ISNULL(SUM(ffpr_Valor), 0)
      FROM FF_Previsao
     WHERE ffpr_Tipo = 'D' 
       AND ffpr_Data = @DataAtual





    -- Insere linha em branco
    INSERT INTO #CalculoPrevisao (Titulo) Values ('')
    


    -- FAZ TOTAL DE DESPESAS DE CONTAS A PAGAR
    -- P E S S O A L
    -- totaliza Pessoal tabela cp_pessoais

    Select @TotalPessoal = ISNULL(sum(cpps_Valor), 0) 
        From CP_Pessoais
        Where cpps_Data = @DataAtual 


    -- T O T A L I Z A C A O     G E R A L
  -- Insere Titulo
  INSERT INTO #CalculoPrevisao (Titulo) Values ('DESPESAS')


    -- GUARDA O TOTAL DE DESPESA
    Select @TotalGeralDespesa =  @TotalPessoal


    -- Insere Pessoal
   INSERT INTO #CalculoPrevisao (Descricao,
                                 Valor,
                                 Data) 
    
    Select 'Pessoal', 
           @TotalPessoal, 
           @DataAtual


   INSERT INTO #CalculoPrevisao (Auxiliar,
                                 AuxiliarValor,
                                 Data) 
    
    Select 'Total', 
           @TotalPessoal,
           @DataAtual



    -- Insere linha em branco
    INSERT INTO #CalculoPrevisao (Titulo) Values ('')
    


    -- Insere total geral
    IF @DataAtual = @DataInicial 

        BEGIN

            SELECT @TotalGeral = @TotalBanco + @TotalCredito - @TotalDebito - @TotalGeralDespesa

        END

    ELSE

        BEGIN

            SELECT @TotalGeral = @TotalCredito - @TotalDebito - @TotalGeralDespesa + @TotalGeral

        END 


    INSERT INTO #CalculoPrevisao (Auxiliar,
                                  AuxiliarValor,
                                  Data) 
     Values ('Previsão do dia',
             @TotalGeral,
             @DataAtual)

-- Insere linha em branco
INSERT INTO #CalculoPrevisao (Linha) SELECT REPLICATE('_', 200)
-- INSERT INTO #CalculoPrevisao (Titulo) Values ('')    

     SELECT @DataAtual = DATEADD(day, 1, @DataAtual)


    END



SELECT * FROM #CalculoPrevisao


END



