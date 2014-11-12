
/****** Object:  Stored Procedure dbo.SPVE_REPRESGERAL_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_REPRESGERAL_RELATORIO    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_REPRESGERAL_RELATORIO

AS

BEGIN

   SELECT verp_Codigo, 
          verp_RazaoSocial,
          verp_DDD,
          verp_Telefone,
          verp_Contato
          
     FROM VE_Representantes

 ORDER BY verp_Codigo

END

