
/****** Object:  Stored Procedure dbo.SPCP_DUPLICATAS_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_DUPLICATAS_RELATORIO    Script Date: 25/08/1999 20:11:54 ******/
 CREATE PROCEDURE SPCP_DUPLICATAS_RELATORIO

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @Fornecedor       char(14) 

AS

BEGIN

--cria tabela temporaria
CREATE TABLE #TabProrrogacao(Fornecedor       char(14)      Not null,
                             DataVencimento   smalldatetime Null,
                             NotaFiscal       char(6)       Null,
                             Parcela          smallint      Null,
                             ValorTotal       money         Null)     
 
INSERT INTO #TabProrrogacao(Fornecedor,
                            DataVencimento,
                            NotaFiscal,
                            Parcela,
                            ValorTotal)     


   SELECT cofc_Codigo,
          Case ISNULL(cpnd_DataProrrogacao, '')
             When '' Then cpnd_DataVencimento
             Else         cpnd_DataProrrogacao
          End DataVencimento,
          cpnd_NotaFiscal,
          cpnd_Parcela,
          cpnd_ValorTotal

         
     FROM CP_NotaFiscalDetalhe,
          CO_Fornecedor

    WHERE cpnd_Fornecedor = @Fornecedor
      AND cpnd_DataVencimento BETWEEN @DataInicial AND @DataFinal
      AND cpnd_DataProrrogacao IS NULL
      AND cpnd_DataPagamento IS NULL
      AND cpnd_Fornecedor = cofc_Codigo
    ORDER BY cpnd_DataVencimento



 INSERT INTO #TabProrrogacao(Fornecedor,
                            DataVencimento,
                            NotaFiscal,
                            Parcela,
                            ValorTotal)     

   SELECT cofc_Codigo,
          Case ISNULL(cpnd_DataProrrogacao, '')
             When '' Then cpnd_DataVencimento
             Else         cpnd_DataProrrogacao
          End DataVencimento,
          cpnd_NotaFiscal,
          cpnd_Parcela,
          cpnd_ValorTotal

     FROM CP_NotaFiscalDetalhe,
          CO_Fornecedor

    WHERE cpnd_Fornecedor = @Fornecedor
      AND cpnd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal 
      AND cpnd_DataPagamento IS NULL
      AND cpnd_Fornecedor = cofc_Codigo
    ORDER BY cpnd_DataProrrogacao



Select * from #TabProrrogacao Order by DataVencimento

END


