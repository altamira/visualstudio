
/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_VISUALIZA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_FORNECEDOR_VISUALIZA    Script Date: 25/08/1999 20:11:39 ******/
CREATE PROCEDURE SPCO_FORNECEDOR_VISUALIZA

AS

BEGIN

   SELECT CASE cofc_tipopessoa 
            WHEN 'F' THEN SUBSTRING(cofc_codigo, 1, 3) + '.' + SUBSTRING(cofc_codigo, 4, 3) + '.' + SUBSTRING(cofc_codigo, 7, 3) + '-' + SUBSTRING(cofc_codigo, 10, 2)   -- Formata CPF
	         WHEN 'J' THEN SUBSTRING(cofc_codigo, 1, 2) + '.' + SUBSTRING(cofc_codigo, 3, 3) + '.' + SUBSTRING(cofc_codigo, 6, 3) + '/' + SUBSTRING(cofc_codigo, 9, 4) + '-' + SUBSTRING(cofc_codigo, 13, 2)  -- Formata CGC
          END 'Código',
          cofc_Abreviado 'Abreviação', 
          cofc_Nome      'Razão Social',
          cofc_DDDTelefone + ' ' + cofc_Telefone  'Telefone'  -- Formata Telefone
     FROM CO_Fornecedor
 ORDER BY cofc_Abreviado

END

