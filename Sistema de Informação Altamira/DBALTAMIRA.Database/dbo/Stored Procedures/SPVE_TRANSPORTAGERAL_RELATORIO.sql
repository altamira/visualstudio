
/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTAGERAL_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTAGERAL_RELATORIO    Script Date: 25/08/1999 20:11:29 ******/
CREATE PROCEDURE SPVE_TRANSPORTAGERAL_RELATORIO

AS

BEGIN

   SELECT vetr_Abreviado, 
                 vetr_Nome,
                 vetr_DDD,
                 vetr_Telefone,
                 vetr_Contato
          
     FROM VE_Transportadoras

          ORDER BY vetr_Abreviado

END


