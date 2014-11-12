
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_MONTA    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_MONTA    Script Date: 18/10/2001 13:53:00 ******/
CREATE PROCEDURE SPCP_NOTAFISCALDET_MONTA
    @DataInicial     smalldatetime,
    @DataFinal       smalldatetime
AS

BEGIN

   SELECT   cpnf_jaincluso, cpnf_DataEntrada, cpnf_NotaFiscal, 
                    cpnf_Parcelas, cpnd_Duplicata, cpnd_Parcela, 
                    cpnd_DataVencimento, cpnd_datapagamento, 
                    cpnd_DataProrrogacao, cpnd_ValorTotal, cofc_Nome
      FROM CP_NotaFiscal, CP_NotaFiscalDetalhe, 
              CO_Fornecedor
     WHERE cpnd_DataVencimento >= @DataInicial  AND cpnd_dataVencimento <= @DataFinal  AND 
                    cpnf_NotaFiscal = cpnd_NotaFiscal     AND 
                    cpnf_Fornecedor = cpnd_Fornecedor  AND 
                    cpnf_TipoNota = cpnd_TipoNota         AND 
                    cpnf_Fornecedor = cofc_Codigo          AND 
                    cpnd_DataPagamento                     IS NOT NULL
     ORDER BY cpnd_dataVencimento          DESC

END






