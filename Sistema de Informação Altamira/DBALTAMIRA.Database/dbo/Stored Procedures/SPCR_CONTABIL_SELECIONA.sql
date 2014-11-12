
/****** Object:  Stored Procedure dbo.SPCR_CONTABIL_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/
/****** Object:  Stored Procedure dbo.SPCR_CONTABIL_SELECIONA    Script Date: 25/08/1999 20:11:40 ******/
CREATE PROCEDURE SPCR_CONTABIL_SELECIONA

@DataFinal     smalldatetime

AS

BEGIN

    SELECT crnd_Notafiscal as fanf_NotaFiscal,
           crnd_TipoNota as fanf_TipoNota,
           crnd_EmissaoNF as fanf_DataNota,
           crnd_Parcela as fanf_QtdePagto,
           crnd_Parcela,
           vecl_Codigo,
           vecl_Nome,
           crnd_ValorTotal,
           crnd_DataVencimento,
           crnd_DataProrrogacao,
           crnd_TipoOperacao

        FROM CR_NotasFiscaisDetalhe,
             VE_Clientes

           WHERE (crnd_DataPagamento IS NULL OR crnd_DataPagamento > @DataFinal)
             AND crnd_NotaFiscal        = crnd_NotaFiscal
             AND crnd_TipoNota          = crnd_TipoNota
             AND crnd_CNPJ              = vecl_Codigo
 
               ORDER BY fanf_NotaFiscal
END




