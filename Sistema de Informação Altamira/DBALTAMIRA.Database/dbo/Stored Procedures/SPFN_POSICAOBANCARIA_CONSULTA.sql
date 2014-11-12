
/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_CONSULTA    Script Date: 25/08/1999 20:11:43 ******/
CREATE PROCEDURE SPFN_POSICAOBANCARIA_CONSULTA

@DataPeriodo    smalldatetime,
@Banco          char(3)
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

CREATE TABLE #TabDias (Dia   int   Not Null, 
                       Valor money Not Null)


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




-- Monta Cursor para totalização dos dias

 DECLARE curValores INSENSITIVE CURSOR
     FOR SELECT DatePart(Day, fnpb_Data),
                fnpb_Valor
          FROM FN_PosBancaria
         WHERE fnpb_Data BETWEEN @DataInicial AND @DataFinal
           And fnpb_Banco = @Banco

OPEN curValores

FETCH NEXT FROM curValores INTO   
                @DiaData,
                @Valor


WHILE @@FETCH_STATUS = 0 

    BEGIN

        UPDATE #TabDias 
           SET Valor = Valor + @Valor
         WHERE Dia = @DiaData
   

        FETCH NEXT FROM curValores INTO
                        @DiaData,
                        @Valor

    END


    CLOSE curValores
DEALLOCATE curValores


SELECT * FROM #TabDias


END



