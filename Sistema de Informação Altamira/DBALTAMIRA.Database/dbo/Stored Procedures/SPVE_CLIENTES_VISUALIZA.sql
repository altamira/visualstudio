
/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_VISUALIZA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_CLIENTES_VISUALIZA    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE SPVE_CLIENTES_VISUALIZA

AS

BEGIN

   SELECT CASE vecl_TipoPessoa 
            WHEN 'F' THEN SUBSTRING(vecl_codigo, 1, 3) + '.' + SUBSTRING(vecl_codigo, 4, 3) + '.' + SUBSTRING(vecl_codigo, 7, 3) + '-' + SUBSTRING(vecl_codigo, 10, 2)   -- Formata CPF
	         WHEN 'J' THEN SUBSTRING(vecl_codigo, 1, 2) + '.' + SUBSTRING(vecl_codigo, 3, 3) + '.' + SUBSTRING(vecl_codigo, 6, 3) + '/' + SUBSTRING(vecl_codigo, 9, 4) + '-' + SUBSTRING(vecl_codigo, 13, 2)  -- Formata CGC
          END 'Código',
          vecl_Abreviado 'Abreviação', 
          vecl_Representante 'Representante'  
     FROM VE_ClientesNovo
 ORDER BY vecl_Abreviado

END


