
/****** Object:  Stored Procedure dbo.SPCP_CONSPREVDIATOTAL_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_CONSPREVDIATOTAL_CONSULTA    Script Date: 25/08/1999 20:11:53 ******/
CREATE PROCEDURE SPCP_CONSPREVDIATOTAL_CONSULTA

@Data      smalldatetime

AS

Declare @TotalFornecedor      money,
        @TotalDespesa         money,
        @TotalImposto         money

BEGIN


-- F O R N E C E D O R
-- totaliza fornecedor tabela cp_notafiscaldetalhe

Select @TotalFornecedor = ISNULL(sum(cpnd_ValorTotal), 0) 
    From CP_NotaFiscalDetalhe
    Where cpnd_DataVencimento = @Data 
      And cpnd_DataProrrogacao Is Null
      And cpnd_DataPagamento Is Null

Select @TotalFornecedor = @TotalFornecedor + ISNULL(sum(cpnd_ValorTotal), 0) 
   From CP_NotaFiscalDetalhe
   Where cpnd_DataProrrogacao = @Data 
     And cpnd_DataPagamento Is Null 

-- totaliza fornecedor tabela cp_previsao

Select @TotalFornecedor = @TotalFornecedor + ISNULL(sum(cppr_Valor), 0) 
    From CP_Previsao
    Where cppr_DataVencimento = @Data 
      And cppr_Tipo = 'F'


-- totaliza fornecedor tabela cp_SinalPedido
Select @TotalFornecedor = @TotalFornecedor + ISNULL(sum(cpsp_Valor), 0) 
    From CP_SinalPedido
    Where cpsp_DataVencimento = @Data 
      And cpsp_DataPagamento Is Null


-- D E S P E S A
-- totaliza Despesa tabela cp_despesaimpostodetalhe

Select @TotalDespesa = ISNULL(sum(cpdd_ValorTotal), 0) 
    From CP_DespesaImpostoDetalhe, CP_DespesaImposto
    Where cpdi_TipoConta = 'D'
      And cpdd_DataVencimento = @Data 
      And cpdd_DataProrrogacao Is Null
      And cpdd_Sequencia = cpdi_Sequencia
      And cpdd_DataPagamento Is Null

Select @TotalDespesa = @TotalDespesa + ISNULL(sum(cpdd_ValorTotal), 0) 
     From CP_DespesaImpostoDetalhe, CP_DespesaImposto
     Where cpdi_TipoConta = 'D'
      And cpdd_DataProrrogacao = @Data 
      And cpdd_Sequencia = cpdi_Sequencia
      And cpdd_DataPagamento Is Null

-- totaliza despesa tabela cp_previsao

Select @TotalDespesa = @TotalDespesa + ISNULL(sum(cppr_Valor), 0)
    From CP_Previsao
    Where cppr_DataVencimento = @Data 
      And cppr_Tipo = 'D'



-- I M P O S T O
-- totaliza Imposto tabela cp_despesaimpostodetalhe

Select @TotalImposto = ISNULL(sum(cpdd_ValorTotal), 0) 
    From CP_DespesaImpostoDetalhe, CP_DespesaImposto
    Where cpdi_TipoConta = 'I'
      And cpdd_DataVencimento = @Data 
      And cpdd_DataProrrogacao Is Null
      And cpdd_Sequencia = cpdi_Sequencia
      And cpdd_DataPagamento Is Null

Select @TotalImposto = @TotalImposto + ISNULL(sum(cpdd_ValorTotal), 0) 
     From CP_DespesaImpostoDetalhe, CP_DespesaImposto
     Where cpdi_TipoConta = 'I'
      And cpdd_DataProrrogacao = @Data 
      And cpdd_Sequencia = cpdi_Sequencia
      And cpdd_DataPagamento Is Null
     
-- totaliza Imposto tabela cp_previsao

Select @TotalImposto = @TotalImposto + ISNULL(sum(cppr_Valor), 0) 
    From CP_Previsao
    Where cppr_DataVencimento = @Data 
      And cppr_Tipo = 'I'



-- T O T A L I Z A C A O     G E R A L

Select @TotalFornecedor AuxTotForn, 
       @TotalDespesa AuxTotDesp,
       @TotalImposto AuxTotImpo,
       @TotalFornecedor + @TotalDespesa + @TotalImposto AuxTotGeral

END	

