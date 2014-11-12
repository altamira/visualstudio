
/****** Object:  Stored Procedure dbo.SPCR_DUPLIPENDCLIENT_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_DUPLIPENDCLIENT_SELECIONA    Script Date: 25/08/1999 20:11:40 ******/
CREATE PROCEDURE SPCR_DUPLIPENDCLIENT_SELECIONA

@Cliente      char(14)

AS

BEGIN

    SELECT crnd_CNPJ ,crnd_EmissaoNF,
           crnd_NotaFiscal,
           crnd_TipoNota,
           crnd_Parcela,
           crnd_ValorTotal,
           ISNULL(crnd_dataprorrogacao, crnd_datavencimento) data, 
           crnd_DataVencimento,
           crnd_DataProrrogacao,
           fnba_NomeBanco,vecl_Nome
           

        FROM  CR_NotasFiscaisDetalhe,
             FN_Bancos, 
	VE_Clientes

           WHERE crnd_CNPJ          = @Cliente
             AND crnd_DataPagamento IS NULL
             AND crnd_Banco         = fnba_Codigo
	AND crnd_CNPJ 	= vecl_Codigo              
               ORDER BY crnd_NotaFiscal,crnd_parcela


END














