
/****** Object:  Stored Procedure dbo.SPVE_RECADOSGRAFREP_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOSGRAFREP_CONSULTA    Script Date: 25/08/1999 20:11:45 ******/
CREATE PROCEDURE SPVE_RECADOSGRAFREP_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime

AS
	
   DECLARE @Total003      integer,     
           @Total004      integer,
           @Total005      integer,
           @Total006      integer,
           @Total007      integer,
           @Total008      integer,
           @Total009      integer,
           @Total010      integer,
           @Total011      integer,
           @Total012      integer

BEGIN

  
   SELECT @Total003 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '003'

   SELECT @Total004 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '004'

   SELECT @Total005 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '005'
 
   SELECT @Total006 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '006'
   
   SELECT @Total007 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '008'

   SELECT @Total008 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '010'
   
   SELECT @Total009 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '012'
   
   SELECT @Total010 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '013'

   SELECT @Total011 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '027'

   SELECT @Total012 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Representante = '041'


   CREATE TABLE #TabRecados(Representante char(3),
                            Total         Integer)

   INSERT INTO #TabRecados Values ('003', ISNULL(@Total003, 0))
   INSERT INTO #TabRecados Values ('004', ISNULL(@Total004, 0))
   INSERT INTO #TabRecados Values ('005', ISNULL(@Total005, 0))
   INSERT INTO #TabRecados Values ('006', ISNULL(@Total006, 0))
   INSERT INTO #TabRecados Values ('008', ISNULL(@Total007, 0))
   INSERT INTO #TabRecados Values ('010', ISNULL(@Total008, 0))
   INSERT INTO #TabRecados Values ('012', ISNULL(@Total009, 0))
   INSERT INTO #TabRecados Values ('013', ISNULL(@Total010, 0))
   INSERT INTO #TabRecados Values ('027', ISNULL(@Total011, 0))
   INSERT INTO #TabRecados Values ('041', ISNULL(@Total012, 0))

   SELECT * FROM #TabRecados ORDER BY Representante

   
END
