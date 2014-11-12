
/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTAINDIV_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTAINDIV_RELATORIO    Script Date: 25/08/1999 20:11:29 ******/
CREATE PROCEDURE SPVE_TRANSPORTAINDIV_RELATORIO

@Abreviado    char(14)

AS

BEGIN

   SELECT * FROM VE_Transportadoras
          
       Where vetr_Abreviado = @Abreviado

END

