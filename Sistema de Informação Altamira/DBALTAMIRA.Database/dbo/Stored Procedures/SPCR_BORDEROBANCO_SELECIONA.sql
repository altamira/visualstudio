
/****** Object:  Stored Procedure dbo.SPCR_BORDEROBANCO_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_BORDEROBANCO_SELECIONA    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCR_BORDEROBANCO_SELECIONA 

AS
	
BEGIN

      SELECT vecl_Nome,
             crbo_NotaFiscal,
             crbo_TipoNota, 
             crbo_Parcela,
             crbo_Banco

         FROM CR_Bordero, VE_Clientes

            WHERE vecl_Codigo = crbo_Cliente

               ORDER BY crbo_NotaFiscal
             
END


