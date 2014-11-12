
/****** Object:  Stored Procedure dbo.SPVE_VISITAS_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_VISITAS_RELATORIO    Script Date: 25/08/1999 20:11:46 ******/
CREATE PROCEDURE SPVE_VISITAS_RELATORIO

@MesAno           char(7),
@Representante    char(3) 
        
AS
	
Declare  @DataInicial    Smalldatetime,
         @DataFinal      Smalldatetime

Begin

    -- Define Data inicial
    SELECT @DataInicial = SUBSTRING(@MesAno, 1, 2) + '/01/' +  SUBSTRING(@MesAno, 4, 4)

    -- Define Data Final
    SELECT @DataFinal = DATEADD(Month, 1, @DataInicial)

    SELECT @DataFinal = DATEADD(Day, -1, @DataFinal)


    SELECT vevi_Data,
           vevi_Nome,
           vevi_Telefone,
           vevi_Contato,
           vevi_Departamento
      
      FROM VE_Visitas

     WHERE vevi_Data  BETWEEN @DataInicial AND @DataFinal
       AND vevi_Representante  = @Representante
       ORDER BY vevi_Data
       
End



