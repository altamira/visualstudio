
/****** Object:  Stored Procedure dbo.SPCR_DUPLIPENDGERAL_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_DUPLIPENDGERAL_SELECIONA    Script Date: 25/08/1999 20:11:40 ******/
CREATE PROCEDURE SPCR_DUPLIPENDGERAL_SELECIONA

AS

BEGIN

    SELECT vecl_Nome,crnd_CNPJ ,crnd_EmissaoNF,
           crnd_NotaFiscal,
           crnd_TipoNota,
           crnd_Parcela,
           crnd_ValorTotal,
           crnd_DataVencimento,
           crnd_DataProrrogacao,
           fnba_NomeBanco

        FROM CR_NotasFiscaisDetalhe,
             VE_Clientes,
             FN_Bancos

           WHERE crnd_DataPagamento IS NULL 
             AND crnd_CNPJ              = vecl_Codigo
             AND crnd_Banco             = fnba_Codigo

               ORDER BY crnd_NotaFiscal


END


