
/****** Object:  Stored Procedure dbo.SPVE_RECADOSGRAFPROP_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOSGRAFPROP_CONSULTA    Script Date: 25/08/1999 20:11:45 ******/
CREATE PROCEDURE SPVE_RECADOSGRAFPROP_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime

AS
	
   DECLARE @Total000      integer,     
           @Total001      integer,
           @Total002      integer,
           @Total003      integer,
           @Total004      integer,
           @Total005      integer,
           @Total006      integer,
           @Total007      integer,
           @Total008      integer,
           @Total009      integer

BEGIN

  
   SELECT @Total000 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 0

   SELECT @Total001 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 1

   SELECT @Total002 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 2
 
   SELECT @Total003 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 3
   
   SELECT @Total004 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 4

   SELECT @Total005 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 5
   
   SELECT @Total006 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 6
   
   SELECT @Total007 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 7

   SELECT @Total008 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 8

   SELECT @Total009 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Propaganda = 9


   CREATE TABLE #TabRecados(Propaganda    char(23),
                            Total         Integer)

   INSERT INTO #TabRecados Values ('JÁ É CLIENTE', ISNULL(@Total000, 0))
   INSERT INTO #TabRecados Values ('JÁ FOI VISITADO', ISNULL(@Total001, 0))
   INSERT INTO #TabRecados Values ('INDICAÇÃO OUTRO CLIENTE', ISNULL(@Total002, 0))
   INSERT INTO #TabRecados Values ('INTERNET', ISNULL(@Total003, 0))
   INSERT INTO #TabRecados Values ('PÁGINAS AMARELAS', ISNULL(@Total004, 0))
   INSERT INTO #TabRecados Values ('LISTAS O.E.S.P.', ISNULL(@Total005, 0))
   INSERT INTO #TabRecados Values ('FEIRAS', ISNULL(@Total006, 0))
   INSERT INTO #TabRecados Values ('REVISTA P.S.', ISNULL(@Total007, 0))
   INSERT INTO #TabRecados Values ('REVISTA NEI', ISNULL(@Total008, 0))
   INSERT INTO #TabRecados Values ('REVISTA TECNOLOGÍSTICA', ISNULL(@Total009, 0))

   SELECT * FROM #TabRecados 

   
END


