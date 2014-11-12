
/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESFOR_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESFOR_CONSULTA    Script Date: 16/10/01 13:41:51 ******/
/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESFOR_CONSULTA    Script Date: 05/01/1999 11:03:43 ******/
 CREATE PROCEDURE SPCP_MOVIMENTOMESFOR_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime
    
AS

BEGIN

--cria tabela temporaria
CREATE TABLE #TabFornecedor(Abreviado        char(14)      Not null,
                            DataEntrada      smalldatetime Null,
                            NotaFiscal       char(6)       Null,
                            ValorTotalCompra money         Null,
                            Parcela          smallint      Null,
                            Parcelas         smallint      Null,
                            Duplicata        char(7)       Null,
                            DataVencimento   smalldatetime Null,
                            ValorTotal       money         Null,
                            NumeroCheque     char(15)      Null,
                            BancoCheque      char(3)       Null,
                            DataPagamento    smalldatetime Null,
                            BancoPagamento   char(3)       Null,
                            CopiaCheque      int           Null, 
                            ValorNaoPago     money         Null)     

INSERT INTO #TabFornecedor(Abreviado,
                           DataEntrada,
                           NotaFiscal,
                           ValorTotalCompra,
                           Parcela,
                           Parcelas,
                           Duplicata,
                           DataVencimento,
                           ValorTotal,
                           NumeroCheque,
                           BancoCheque,
                           DataPagamento,
                           BancoPagamento,
                           CopiaCheque,
                           ValorNaoPago)     


   SELECT cofc_Abreviado,
          cpnf_DataEntrada,
          cpnf_NotaFiscal,
          cpnf_ValorTotal,
          cpnd_Parcela,
          cpnf_Parcelas,
          cpnd_Duplicata,
          Case ISNULL(cpnd_DataProrrogacao, '')
             When '' Then cpnd_DataVencimento
             Else         cpnd_DataProrrogacao
          End DataVencimento,    
          cpnd_ValorTotal,
          cpnd_NumeroCheque,
          cpnd_BancoCheque,
          cpnd_DataPagamento,
          cpnd_BancoPagamento,
          cpnd_CopiaCheque,
          Case ISNULL(cpnd_DataPagamento, '')
             When '' Then cpnd_ValorTotal
             Else 0
          End ValorNaoPago       
     
     FROM CP_NotaFiscal,
          CP_NotaFiscalDetalhe,
          CO_Fornecedor

    WHERE cpnd_DataVencimento BETWEEN @DataInicial AND @DataFinal
      AND cpnd_DataProrrogacao IS NULL
      AND cpnf_NotaFiscal = cpnd_NotaFiscal
      AND cpnf_Fornecedor = cpnd_Fornecedor
      AND cpnf_TipoNota = cpnd_TipoNota
      AND cpnf_Fornecedor = cofc_Codigo
    ORDER BY cpnd_DataVencimento

 INSERT INTO #TabFornecedor(Abreviado,
                            DataEntrada,
                            NotaFiscal,
                            ValorTotalCompra,
                            Parcela,
                            Parcelas,
                            Duplicata,
                            DataVencimento,
                            ValorTotal,
                            NumeroCheque,
                            BancoCheque,
                            DataPagamento,
                            BancoPagamento,
                            CopiaCheque,
                            ValorNaoPago)     

   SELECT cofc_Abreviado,
          cpnf_DataEntrada,
          cpnf_NotaFiscal,
          cpnf_ValorTotal,
          cpnd_Parcela,
          cpnf_Parcelas,
          cpnd_Duplicata,
          Case ISNULL(cpnd_DataProrrogacao, '')
            When '' Then cpnd_DataVencimento
            Else         cpnd_DataProrrogacao
          End DataVencimento,  
          cpnd_ValorTotal,
          cpnd_NumeroCheque,
          cpnd_BancoCheque,
          cpnd_DataPagamento,
          cpnd_BancoPagamento,
          cpnd_CopiaCheque,
          Case ISNULL(cpnd_DataPagamento, '')
             When '' Then cpnd_ValorTotal
             Else 0
          End ValorNaoPago     
     
     FROM CP_NotaFiscal,
          CP_NotaFiscalDetalhe,
          CO_Fornecedor

    WHERE cpnd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal
      AND cpnf_NotaFiscal = cpnd_NotaFiscal
      AND cpnf_Fornecedor = cpnd_Fornecedor
      AND cpnf_TipoNota = cpnd_TipoNota
      AND cpnf_Fornecedor = cofc_Codigo
    ORDER BY cpnd_DataProrrogacao


-- Traz o sinal
INSERT INTO #TabFornecedor(Abreviado,
                           DataEntrada,
                           NotaFiscal,
                           ValorTotalCompra,
                           Parcela,
                           Parcelas,
                           Duplicata,
                           DataVencimento,
                           ValorTotal,
                           NumeroCheque,
                           BancoCheque,
                           DataPagamento,
                           BancoPagamento,
                           CopiaCheque,
                           ValorNaoPago)     


   SELECT cofc_Abreviado,
          cope_Data,
          'Sinal',
          cpsp_Valor,
          1,
          1,
          '-----',
          
          cpsp_DataVencimento,
          cpsp_Valor,
          cpsp_NumeroCheque,
          cpsp_BancoCheque,
          cpsp_DataPagamento,
          cpsp_BancoPagamento,
          cpsp_CopiaCheque,
          Case ISNULL(cpsp_DataPagamento, '')
             When '' Then cpsp_Valor
             Else 0
          End ValorNaoPago       
     
     FROM CP_SinalPedido,
          CO_Pedido,
          CO_Fornecedor

    WHERE cpsp_DataVencimento BETWEEN @DataInicial AND @DataFinal
      AND cope_Numero = cpsp_Pedido
      AND cope_Fornecedor = cofc_Codigo
    ORDER BY cpsp_DataVencimento

 
Select * from #TabFornecedor Order by DataVencimento, Abreviado

END


