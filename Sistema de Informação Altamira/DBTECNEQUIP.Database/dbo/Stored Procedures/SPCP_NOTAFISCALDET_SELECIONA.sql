
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_SELECIONA    Script Date: 23/10/2010 15:32:31 ******/


/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_SELECIONA    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_NOTAFISCALDET_SELECIONA

@TipoConsulta       char(1)

AS

BEGIN

   IF @TipoConsulta = 'I' 
      BEGIN
	    SELECT  CASE cofc_tipopessoa 
             	         WHEN 'F' THEN SUBSTRING(cofc_codigo, 1, 3) + '.' + SUBSTRING(cofc_codigo, 4, 3) + '.' + SUBSTRING(cofc_codigo, 7, 3) + '-' + SUBSTRING(cofc_codigo, 10, 2) + ' - ' +  cofc_Abreviado + '  ' + cpnf_NotaFiscal +  ' - Ped.' + Convert(varchar, cpnf_Pedido) -- Formata CPF
	         WHEN 'J' THEN SUBSTRING(cofc_codigo, 1, 2) + '.' + SUBSTRING(cofc_codigo, 3, 3) + '.' + SUBSTRING(cofc_codigo, 6, 3) + '/' + SUBSTRING(cofc_codigo, 9, 4) + '-' + SUBSTRING(cofc_codigo, 13, 2) + ' - ' + cofc_Abreviado + '  ' + cpnf_NotaFiscal +  ' - Ped.' + Convert(varchar, cpnf_Pedido) -- Formata CGC
                  END 'Codigo', cofc_Codigo, cpnf_NotaFiscal, cpnf_TipoNota, cpnf_Pedido, cofc_Abreviado, cofc_tipopessoa 
	     FROM CO_Fornecedor, CP_NotaFiscal
	     WHERE 	cofc_Codigo = cpnf_Fornecedor
		   AND 	cpnf_JaIncluso = 'N'
	     ORDER BY cofc_Abreviado
	  
	  END 

    ELSE

       BEGIN

	    SELECT CASE cofc_tipopessoa 
                       WHEN 'F' THEN SUBSTRING(cofc_codigo, 1, 3) + '.' + SUBSTRING(cofc_codigo, 4, 3) + '.' + SUBSTRING(cofc_codigo, 7, 3) + '-' + SUBSTRING(cofc_codigo, 10, 2) + ' - ' + cofc_Abreviado + '   ' + cpnf_NotaFiscal +  ' - Ped.' + Convert(varchar, cpnf_Pedido)  -- Formata CPF
	          WHEN 'J' THEN SUBSTRING(cofc_codigo, 1, 2) + '.' + SUBSTRING(cofc_codigo, 3, 3) + '.' + SUBSTRING(cofc_codigo, 6, 3) + '/' + SUBSTRING(cofc_codigo, 9, 4) + '-' + SUBSTRING(cofc_codigo, 13, 2) + ' - ' + cofc_Abreviado + '  '+ cpnf_NotaFiscal +  ' - Ped.' + Convert(varchar, cpnf_Pedido) -- Formata CGC
                 END 'Codigo' , cofc_Codigo, cpnf_NotaFiscal, cpnf_TipoNota, cpnf_Pedido, cofc_Abreviado,cofc_tipopessoa 
                 FROM CO_Fornecedor, CP_NotaFiscal, CP_NotaFiscalDetalhe
	    WHERE cofc_Codigo = cpnf_Fornecedor
		AND cpnf_Fornecedor = cpnd_Fornecedor
		AND cpnf_NotaFiscal = cpnd_NotaFiscal
		AND cpnf_TipoNota = cpnd_TipoNota
		AND cpnf_Pedido   = cpnd_Pedido
		AND cpnf_JaIncluso = 'S'
                 ORDER BY cofc_Abreviado

	  
       END   

END





