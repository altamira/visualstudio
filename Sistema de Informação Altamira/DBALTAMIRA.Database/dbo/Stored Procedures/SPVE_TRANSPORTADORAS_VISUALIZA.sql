
/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_VISUALIZA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_TRANSPORTADORAS_VISUALIZA    Script Date: 25/08/1999 20:11:29 ******/
CREATE PROCEDURE SPVE_TRANSPORTADORAS_VISUALIZA

AS

BEGIN

   SELECT vetr_Codigo,
          SUBSTRING(vetr_CGC, 1, 2) + '.' + SUBSTRING(vetr_CGC, 3, 3) + '.' + SUBSTRING(vetr_CGC, 6, 3) + '/' + SUBSTRING(vetr_CGC, 9, 4) + '-' + SUBSTRING(vetr_CGC, 13, 2)  'C.G.C.',
          vetr_Nome      'Razão Social'
          
     FROM VE_Transportadoras

 ORDER BY vetr_Nome

END

