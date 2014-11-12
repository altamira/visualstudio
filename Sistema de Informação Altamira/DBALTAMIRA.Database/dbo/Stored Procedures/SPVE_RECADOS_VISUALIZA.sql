
/****** Object:  Stored Procedure dbo.SPVE_RECADOS_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_RECADOS_VISUALIZA    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPVE_RECADOS_VISUALIZA

@DataInicial     smalldatetime,
@DataFinal       smalldatetime

AS

 Select vere_Numero 'Número',
        vere_Data 'Data',
        vere_Abreviado 'Abreviado',
        vere_Representante 'Representante'

     From VE_Recados

     Where  vere_Data Between  @DataInicial And  @DataFinal

     Order By vere_Data, vere_Representante, vere_Abreviado 
