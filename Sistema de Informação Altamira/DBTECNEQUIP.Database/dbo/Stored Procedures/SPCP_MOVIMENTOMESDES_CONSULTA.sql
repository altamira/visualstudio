
/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESDES_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESDES_CONSULTA    Script Date: 16/10/01 13:41:48 ******/
/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESDES_CONSULTA    Script Date: 05/01/1999 11:03:43 ******/
 CREATE PROCEDURE SPCP_MOVIMENTOMESDES_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime
    
AS

BEGIN

--cria tabela temporaria
CREATE TABLE #TabFornecedor(Descricao        char(40)      Not null,
                            DataEmissao      smalldatetime Null,
                            ValorTotalCompra money         Null,
                            Parcela          smallint      Null,
                            Parcelas         smallint      Null,
                            Observacao       varchar(50)       Null,
                            DataVencimento   smalldatetime Null,
                            ValorTotal       money         Null,
                            NumeroCheque     char(15)      Null,
                            BancoCheque      char(3)       Null,
                            DataPagamento    smalldatetime Null,
                            BancoPagamento   char(3)       Null,
                            CopiaCheque      int           Null, 
                            ValorNaoPago     money         Null)     

INSERT INTO #TabFornecedor(Descricao,
                           DataEmissao,
                           ValorTotalCompra,
                           Parcela,
                           Parcelas,
                           Observacao,
                           DataVencimento,
                           ValorTotal,
                           NumeroCheque,
                           BancoCheque,
                           DataPagamento,
                           BancoPagamento,
                           CopiaCheque,
                           ValorNaoPago)     


   SELECT cpde_Descricao,
          cpdi_DataEmissao,
          cpdi_ValorTotal,
          cpdd_Parcela,
          cpdi_Parcelas,
          cpdd_Observacao,
          Case ISNULL(cpdd_DataProrrogacao, '')
             When '' Then cpdd_DataVencimento
             Else         cpdd_DataProrrogacao
          End DataVencimento,    
          cpdd_ValorTotal,
          cpdd_NumeroCheque,
          cpdd_BancoCheque,
          cpdd_DataPagamento,
          cpdd_BancoPagamento,
          cpdd_CopiaCheque,
          Case ISNULL(cpdd_DataPagamento, '')
             When '' Then cpdd_ValorTotal
             Else 0
          End ValorNaoPago       
     
     FROM CP_DespesaImposto,
          CP_DespesaImpostoDetalhe,
          CP_Descricao

    WHERE cpdd_DataVencimento BETWEEN @DataInicial AND @DataFinal
      AND cpdd_DataProrrogacao IS NULL
      AND cpdd_Sequencia = cpdi_Sequencia
      AND cpde_Codigo = cpdi_CodigoConta
      AND cpde_Tipo = cpdi_TipoConta
      AND cpdi_TipoConta = 'D'
    ORDER BY cpdd_DataVencimento

 INSERT INTO #TabFornecedor(Descricao,
                           DataEmissao,
                           ValorTotalCompra,
                           Parcela,
                           Parcelas,
                           Observacao,
                           DataVencimento,
                           ValorTotal,
                           NumeroCheque,
                           BancoCheque,
                           DataPagamento,
                           BancoPagamento,
                           CopiaCheque,
                           ValorNaoPago)  

   SELECT cpde_Descricao,
          cpdi_DataEmissao,
          cpdi_ValorTotal,
          cpdd_Parcela,
          cpdi_Parcelas,
          cpdd_Observacao,
          Case ISNULL(cpdd_DataProrrogacao, '')
             When '' Then cpdd_DataVencimento
             Else         cpdd_DataProrrogacao
          End DataVencimento,    
          cpdd_ValorTotal,
          cpdd_NumeroCheque,
          cpdd_BancoCheque,
          cpdd_DataPagamento,
          cpdd_BancoPagamento,
          cpdd_CopiaCheque,
          Case ISNULL(cpdd_DataPagamento, '')
             When '' Then cpdd_ValorTotal
             Else 0
          End ValorNaoPago       
     
     FROM CP_DespesaImposto,
          CP_DespesaImpostoDetalhe,
          CP_Descricao

    WHERE cpdd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal
      AND cpdd_Sequencia = cpdi_Sequencia
      AND cpde_Codigo = cpdi_CodigoConta
      AND cpde_Tipo = cpdi_TipoConta
      AND cpdi_TipoConta = 'D'
    ORDER BY cpdd_DataVencimento


Select * from #TabFornecedor Order by DataVencimento, Descricao

END


