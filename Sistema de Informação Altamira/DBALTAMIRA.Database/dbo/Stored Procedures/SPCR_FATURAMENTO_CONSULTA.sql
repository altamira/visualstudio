
/****** Object:  Stored Procedure dbo.SPCR_FATURAMENTO_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_FATURAMENTO_CONSULTA    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCR_FATURAMENTO_CONSULTA

@DataPeriodo    smalldatetime

AS

BEGIN

Declare @DataInicial   smalldatetime,
        @DataFinal     smallDatetime,
        @DiaData       int,
        @Pedido        money,
        @Entrega       money,
        @Faturado      money

-- define data inicial

Select @DataInicial = @DataPeriodo

-- define data final

Select @DataFinal = DateAdd(Month, 1, @DataInicial)
Select @DataFinal = DateAdd(Day, -1, @DataFinal)

-- cria tabela

CREATE TABLE #TabDias (Dia           int   Not Null, 
                       ValorPedido   money Not Null,
                       ValorEntrega  money Not Null,
                       ValorFaturado money Not Null)


-- Insere os Dias na tabela
INSERT INTO #TabDias Values (1, 0, 0, 0)
INSERT INTO #TabDias values (2, 0, 0, 0)
INSERT INTO #TabDias values (3, 0, 0, 0)
INSERT INTO #TabDias Values (4, 0, 0, 0)
INSERT INTO #TabDias Values (5, 0, 0, 0)
INSERT INTO #TabDias Values (6, 0, 0, 0)
INSERT INTO #TabDias Values (7, 0, 0, 0)
INSERT INTO #TabDias Values (8, 0, 0, 0)
INSERT INTO #TabDias Values (9, 0, 0, 0)
INSERT INTO #TabDias Values (10, 0, 0, 0)
INSERT INTO #TabDias Values (11, 0, 0, 0)
INSERT INTO #TabDias Values (12, 0, 0, 0)
INSERT INTO #TabDias Values (13, 0, 0, 0)
INSERT INTO #TabDias Values (14, 0, 0, 0)
INSERT INTO #TabDias Values (15, 0, 0, 0)
INSERT INTO #TabDias Values (16, 0, 0, 0)
INSERT INTO #TabDias Values (17, 0, 0, 0)
INSERT INTO #TabDias Values (18, 0, 0, 0)
INSERT INTO #TabDias Values (19, 0, 0, 0)
INSERT INTO #TabDias Values (20, 0, 0, 0)
INSERT INTO #TabDias Values (21, 0, 0, 0)
INSERT INTO #TabDias Values (22, 0, 0, 0)
INSERT INTO #TabDias Values (23, 0, 0, 0)
INSERT INTO #TabDias Values (24, 0, 0, 0)
INSERT INTO #TabDias Values (25, 0, 0, 0)
INSERT INTO #TabDias Values (26, 0, 0, 0)
INSERT INTO #TabDias Values (27, 0, 0, 0)
INSERT INTO #TabDias Values (28, 0, 0, 0)

-- Verifica quantos dias tem o mes

IF DATEPART(Day, @DataFinal) > 28 

    BEGIN

        -- Caso tenha insere na tabela
        INSERT INTO #TabDias Values (29, 0, 0, 0)

        IF DATEPART(Day, @DataFinal) > 29

            BEGIN

              INSERT INTO #TabDias Values (30, 0, 0, 0)

              IF DATEPART(Day, @DataFinal) > 30

                     BEGIN

                        INSERT INTO #TabDias Values (31, 0, 0, 0)

                     END 

            END
    END


-- Monta Cursor para totalização de recibos
DECLARE curValores INSENSITIVE CURSOR
    FOR SELECT DatePart(Day, crre_DataRecibo),
               crre_ValorRecibo
          FROM CR_Recibos
         WHERE crre_DataRecibo BETWEEN @DataInicial AND @DataFinal
           
OPEN curValores

FETCH NEXT FROM curValores INTO @DiaData,
                                @Pedido
                

WHILE @@FETCH_STATUS = 0

    BEGIN

        UPDATE #TabDias 
           SET ValorPedido = ValorPedido + @Pedido
               WHERE Dia = @DiaData
   
        FETCH NEXT FROM curValores INTO  @DiaData,
                                         @Pedido
    
    END

    CLOSE curValores
DEALLOCATE curValores

-- Notas Fiscais faturamento = na entrega
DECLARE curValoresReais INSENSITIVE CURSOR
    FOR SELECT DatePart(Day, crnd_DataPagamento),
               crnd_ValorTotal 
          FROM CR_NotasFiscaisDetalhe
            WHERE crnd_DataPagamento BETWEEN @DataInicial AND @DataFinal 
              And crnd_TipoFaturamento = '4'

OPEN curValoresReais

FETCH NEXT FROM curValoresReais INTO
                @DiaData,
                @Entrega
             
WHILE @@FETCH_STATUS = 0 

    BEGIN
         
         UPDATE #TabDias
             SET ValorEntrega = ValorEntrega + @Entrega
                    WHERE Dia = @DiaData
    
        FETCH NEXT FROM curValoresReais INTO  @DiaData,
                                              @Entrega

    END

    CLOSE curValoresReais
DEALLOCATE curValoresReais

-- Notas Fiscais com prorrogacao e faturamento = faturado
DECLARE curValoresReais INSENSITIVE CURSOR
    FOR SELECT DatePart(Day, crnd_DataPagamento),
               crnd_ValorTotal 
          FROM CR_NotasFiscaisDetalhe
            WHERE crnd_DataPagamento BETWEEN @DataInicial AND @DataFinal 
              And crnd_TipoFaturamento = '5'

OPEN curValoresReais

FETCH NEXT FROM curValoresReais INTO
                @DiaData,
                @Faturado
             
WHILE @@FETCH_STATUS = 0 

    BEGIN
         
         UPDATE #TabDias
             SET ValorFaturado = ValorFaturado + @Faturado
                    WHERE Dia = @DiaData
    
        FETCH NEXT FROM curValoresReais INTO  @DiaData,
                                              @Faturado

    END

    CLOSE curValoresReais
DEALLOCATE curValoresReais

SELECT * FROM #TabDias


END



