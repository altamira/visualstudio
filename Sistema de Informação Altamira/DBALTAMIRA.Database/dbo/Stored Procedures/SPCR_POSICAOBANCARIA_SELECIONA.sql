
/****** Object:  Stored Procedure dbo.SPCR_POSICAOBANCARIA_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCR_POSICAOBANCARIA_SELECIONA    Script Date: 25/08/1999 20:11:33 ******/
CREATE PROCEDURE SPCR_POSICAOBANCARIA_SELECIONA

@DataPeriodo    smalldatetime,
@Banco          char(3),
@Tipo           char(1)

AS

BEGIN

Declare @DataInicial   smalldatetime,
        @DataFinal     smallDatetime,
        @DiaData       int,
        @Valor         money
 
-- define data inicial

Select @DataInicial = @DataPeriodo

-- define data final

Select @DataFinal = DateAdd(Month, 1, @DataInicial)
Select @DataFinal = DateAdd(Day, -1, @DataFinal)

-- cria tabela

CREATE TABLE #TabDias (Dia     int   Not Null, 
                       Valor   money Not Null)


-- Insere os Dias na tabela
INSERT INTO #TabDias Values (1, 0)
INSERT INTO #TabDias values (2, 0)
INSERT INTO #TabDias values (3, 0)
INSERT INTO #TabDias Values (4, 0)
INSERT INTO #TabDias Values (5, 0)
INSERT INTO #TabDias Values (6, 0)
INSERT INTO #TabDias Values (7, 0)
INSERT INTO #TabDias Values (8, 0)
INSERT INTO #TabDias Values (9, 0)
INSERT INTO #TabDias Values (10, 0)
INSERT INTO #TabDias Values (11, 0)
INSERT INTO #TabDias Values (12, 0)
INSERT INTO #TabDias Values (13, 0)
INSERT INTO #TabDias Values (14, 0)
INSERT INTO #TabDias Values (15, 0)
INSERT INTO #TabDias Values (16, 0)
INSERT INTO #TabDias Values (17, 0)
INSERT INTO #TabDias Values (18, 0)
INSERT INTO #TabDias Values (19, 0)
INSERT INTO #TabDias Values (20, 0)
INSERT INTO #TabDias Values (21, 0)
INSERT INTO #TabDias Values (22, 0)
INSERT INTO #TabDias Values (23, 0)
INSERT INTO #TabDias Values (24, 0)
INSERT INTO #TabDias Values (25, 0)
INSERT INTO #TabDias Values (26, 0)
INSERT INTO #TabDias Values (27, 0)
INSERT INTO #TabDias Values (28, 0)

-- Verifica quantos dias tem o mes

IF DATEPART(Day, @DataFinal) > 28 

    BEGIN

        -- Caso tenha insere na tabela
        INSERT INTO #TabDias Values (29, 0)

        IF DATEPART(Day, @DataFinal) > 29

            BEGIN

              INSERT INTO #TabDias Values (30, 0)

              IF DATEPART(Day, @DataFinal) > 30

                     BEGIN

                        INSERT INTO #TabDias Values (31, 0)

                     END 

            END
    END


-- Pega Registros para fazer a totalizacao dos reais primeiro por data de Prorrogacao 
DECLARE curValoresReais INSENSITIVE CURSOR
    FOR SELECT DatePart(Day, crnd_DataProrrogacao),
               crnd_ValorTotal
          FROM CR_NotasFiscaisDetalhe
         WHERE crnd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal 
           And crnd_DataPagamento Is Null
           And crnd_Banco = @Banco
           And crnd_TipoOperacao = @Tipo

OPEN curValoresReais

FETCH NEXT FROM curValoresReais INTO
                @DiaData,
                @Valor
             
WHILE @@FETCH_STATUS = 0 

    BEGIN

        UPDATE #TabDias 
           SET Valor = Valor + @Valor
         WHERE Dia = @DiaData
   
        FETCH NEXT FROM curValoresReais INTO  @DiaData,
                                              @Valor

    END

    CLOSE curValoresReais
DEALLOCATE curValoresReais

-- Pega Registros para fazer a totalizacao dos reais data de Vencimento
DECLARE curValoresReais INSENSITIVE CURSOR
    FOR SELECT DatePart(Day, crnd_DataVencimento),
               crnd_ValorTotal
          FROM CR_NotasFiscaisDetalhe
         WHERE crnd_DataProrrogacao Is Null
           And crnd_DataVencimento BETWEEN @DataInicial AND @DataFinal
           And crnd_DataPagamento Is Null
           And crnd_Banco = @Banco
           And crnd_TipoOperacao = @Tipo

OPEN curValoresReais

FETCH NEXT FROM curValoresReais INTO
                @DiaData,
                @Valor
             
WHILE @@FETCH_STATUS = 0 

    BEGIN

        UPDATE #TabDias 
           SET Valor = Valor + @Valor
         WHERE Dia = @DiaData
   
        FETCH NEXT FROM curValoresReais INTO  @DiaData,
                                              @Valor

    END

    CLOSE curValoresReais
DEALLOCATE curValoresReais


SELECT * FROM #TabDias


END



