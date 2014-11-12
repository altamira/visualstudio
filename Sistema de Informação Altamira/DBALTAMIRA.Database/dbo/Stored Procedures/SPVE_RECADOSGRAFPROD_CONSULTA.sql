
/****** Object:  Stored Procedure dbo.SPVE_RECADOSGRAFPROD_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOSGRAFPROD_CONSULTA    Script Date: 25/08/1999 20:11:45 ******/
CREATE PROCEDURE SPVE_RECADOSGRAFPROD_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime

AS
	
   DECLARE @Total000      integer,     
           @Total001      integer,
           @Total002      integer,
           @Total003      integer,
           @Total004      integer,
           @Total005      integer,
           @Total006      integer

BEGIN

  
   SELECT @Total000 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 0

   SELECT @Total001 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 1

   SELECT @Total002 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 2
 
   SELECT @Total003 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 3
   
   SELECT @Total004 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 4

   SELECT @Total005 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 5
   
   SELECT @Total006 = Count(*) 
      FROM VE_Recados
         WHERE vere_Data BETWEEN @DataInicial AND @DataFinal
             AND vere_Produto = 6
   
   
   CREATE TABLE #TabRecados(Produtos    char(20),
                            Total       Integer)

   INSERT INTO #TabRecados Values ('ESTANTES/BALCÕES', ISNULL(@Total000, 0))
   INSERT INTO #TabRecados Values ('PORTA-PALETES', ISNULL(@Total001, 0))
   INSERT INTO #TabRecados Values ('MEZANINO', ISNULL(@Total002, 0))
   INSERT INTO #TabRecados Values ('PAINÉIS', ISNULL(@Total003, 0))
   INSERT INTO #TabRecados Values ('DRIVE-IN', ISNULL(@Total004, 0))
   INSERT INTO #TabRecados Values ('PRODUTOS DIVERSOS', ISNULL(@Total005, 0))
   INSERT INTO #TabRecados Values ('PRESTAÇÃO DE SERVIÇO', ISNULL(@Total006, 0))
   

   SELECT * FROM #TabRecados 

   
END


