
/****** Object:  Stored Procedure dbo.SPVE_VISITAS_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_VISITAS_VISUALIZA    Script Date: 25/08/1999 20:11:46 ******/
CREATE PROCEDURE SPVE_VISITAS_VISUALIZA

@DataInicial     smalldatetime,
@DataFinal       smalldatetime

AS

 Select vevi_Abreviado 'Abreviado',
        vevi_Data 'Última Visita',
        vevi_Representante 'Representante',
        vevi_Numero 'Sequencia'

     From VE_Visitas

     Where  vevi_Data  Between  @DataInicial And  @DataFinal

     Order By vevi_Data, vevi_Representante, vevi_Abreviado 





