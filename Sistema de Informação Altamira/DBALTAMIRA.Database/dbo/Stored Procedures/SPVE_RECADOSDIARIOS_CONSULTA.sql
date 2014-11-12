
/****** Object:  Stored Procedure dbo.SPVE_RECADOSDIARIOS_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOSDIARIOS_CONSULTA    Script Date: 25/08/1999 20:11:45 ******/
CREATE PROCEDURE SPVE_RECADOSDIARIOS_CONSULTA

@DataPeriodo    smalldatetime

AS

BEGIN

Declare @DataInicial   smalldatetime,
        @DataFinal     smallDatetime,
        @DiaData       int,
        @Quantidade    int        
 
-- define data inicial

Select @DataInicial = @DataPeriodo

-- define data final

Select @DataFinal = DateAdd(Month, 1, @DataInicial)
Select @DataFinal = DateAdd(Day, -1, @DataFinal)

-- cria tabela

CREATE TABLE #TabDias (Dia     int   Not Null, 
                       Quantidade   int Not Null)
                       

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
DECLARE curQuantidades INSENSITIVE CURSOR
    FOR SELECT DatePart(Day, vere_Data),
               1
          FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
           
OPEN curQuantidades

FETCH NEXT FROM curQuantidades INTO
                @DiaData,
                @Quantidade

WHILE @@FETCH_STATUS = 0 

    BEGIN

        UPDATE #TabDias 
           SET Quantidade = Quantidade + @Quantidade
         WHERE Dia = @DiaData
   
        FETCH NEXT FROM curQuantidades INTO  @DiaData,
                                             @Quantidade 

    END

    CLOSE curQuantidades
DEALLOCATE curQuantidades


SELECT * FROM #TabDias


END



