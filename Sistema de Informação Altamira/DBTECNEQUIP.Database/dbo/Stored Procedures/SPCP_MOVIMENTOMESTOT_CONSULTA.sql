
/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESTOT_CONSULTA    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESTOT_CONSULTA    Script Date: 16/10/01 13:41:52 ******/
/****** Object:  Stored Procedure dbo.SPCP_MOVIMENTOMESTOT_CONSULTA    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_MOVIMENTOMESTOT_CONSULTA

@DataInicial      smalldatetime,
@DataFinal        smalldatetime

AS

Declare @TotalFornecedor          money,
        @TotalNaoPagoFornecedor   money,
        @TotalDespesa             money,
        @TotalNaoPagoDespesa      money,
        @TotalImposto             money,
        @TotalNaoPagoImposto      money,
        @TotalGeral               money,
        @TotalNaoPagoGeral        money

Begin
    --  Totaliza Fornecedor
    Select @TotalFornecedor = IsNull(Sum(cpnd_ValorTotal), 0)
      From CP_NotaFiscalDetalhe
      Where cpnd_DataVencimento Between @DataInicial And @DataFinal
        And cpnd_DataProrrogacao Is Null

    Select @TotalFornecedor = @TotalFornecedor + IsNull(Sum(cpnd_ValorTotal), 0)
      From CP_NotaFiscalDetalhe
      Where cpnd_DataProrrogacao Between @DataInicial And @DataFinal
   
    --  Totaliza Fornecedor nao pagos   
    Select @TotalNaoPagoFornecedor = IsNull(Sum(cpnd_ValorTotal), 0)
      From CP_NotaFiscalDetalhe
      Where cpnd_DataVencimento Between @DataInicial And @DataFinal
        And cpnd_DataProrrogacao Is Null
        And cpnd_DataPagamento Is Null

    Select @TotalNaoPagoFornecedor = @TotalNaoPagoFornecedor + IsNull(Sum(cpnd_ValorTotal), 0)
      From CP_NotaFiscalDetalhe
      Where cpnd_DataProrrogacao Between @DataInicial And @DataFinal
        And cpnd_DataPagamento Is Null


    --  Totaliza Despesa
    Select @TotalDespesa = IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataVencimento Between @DataInicial And @DataFinal
        And cpdd_DataProrrogacao Is Null
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'D'

    Select @TotalDespesa = @TotalDespesa + IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataProrrogacao Between @DataInicial And @DataFinal
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'D'

    --  Totaliza Despesa nao paga
    Select @TotalNaoPagoDespesa = IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataVencimento Between @DataInicial And @DataFinal
        And cpdd_DataProrrogacao Is Null
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'D'
        And cpdd_DataPagamento Is Null

    Select @TotalNaoPagoDespesa = @TotalNaoPagoDespesa + IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataProrrogacao Between @DataInicial And @DataFinal
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'D'
        And cpdd_DataPagamento Is Null



    --  Totaliza Imposto
    Select @TotalImposto = IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataVencimento Between @DataInicial And @DataFinal
        And cpdd_DataProrrogacao Is Null
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'I'

    Select @TotalImposto = @TotalImposto + IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataProrrogacao Between @DataInicial And @DataFinal
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'I'

    --  Totaliza Imposto nao pago
    Select @TotalNaoPagoImposto = IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataVencimento Between @DataInicial And @DataFinal
        And cpdd_DataProrrogacao Is Null
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'I'
        And cpdd_DataPagamento Is Null

    Select @TotalNaoPagoImposto = @TotalNaoPagoImposto + IsNull(Sum(cpdd_ValorTotal), 0)
      From CP_DespesaImpostoDetalhe, CP_DespesaImposto
      Where cpdd_DataProrrogacao Between @DataInicial And @DataFinal
        And cpdd_Sequencia = cpdi_Sequencia
        And cpdi_TipoConta = 'I'
        And cpdd_DataPagamento Is Null


    --  Totaliza Geral
    Select @TotalGeral = @TotalFornecedor + 
                         @TotalDespesa +
                         @TotalImposto, 
           @TotalNaoPagoGeral = @TotalNaoPagoFornecedor +
                                @TotalNaoPagoDespesa +
                                @TotalNaoPagoImposto


 

    --  Retorna as variaveis
    Select @TotalFornecedor TotalFornecedor, @TotalNaoPagoFornecedor TotalAPagarFornecedor,
           @TotalDespesa TotalDespesa, @TotalNaoPagoDespesa TotalAPagarDespesa,
           @TotalImposto TotalImposto, @TotalNaoPagoImposto TotalAPagarImposto,
           @TotalGeral TotalGeral, @TotalNaoPagoGeral TotalAPagarGeral


End
	

