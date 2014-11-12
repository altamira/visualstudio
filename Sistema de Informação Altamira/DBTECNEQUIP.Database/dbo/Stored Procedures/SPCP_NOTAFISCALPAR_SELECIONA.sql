
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALPAR_SELECIONA    Script Date: 23/10/2010 15:32:31 ******/


/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALPAR_SELECIONA    Script Date: 25/08/1999 20:11:23 ******/
CREATE PROCEDURE SPCP_NOTAFISCALPAR_SELECIONA

	@CodigoFornecedor	char(14),
	@NumeroNota         char(6),
    @TipoNota           char(1),
    @Pedido             int
    
AS

BEGIN

    SELECT cpnd_Parcela,
           cpnd_DataVencimento,
           cpnd_DataProrrogacao,
           cpnd_Valor,
           cpnd_ValorMulta,
           cpnd_ValorDesconto,
           cpnd_ValorTotal,
           cpnd_NumeroCheque,
           cpnd_BancoCheque,
           cpnd_CopiaCheque,
           cpnd_DataPagamento,
           cpnd_BancoPagamento,
           cpnd_DataPreDatado,
           cpnd_Grupo,
           cpnd_Destinacao,
           cpnd_Duplicata,
           cpnd_Observacao,
           cpnd_NumeroOP,
           cpnd_DataOP,
	cpnd_ObservaçãoProrrogação,
	cpnd_ObservacãoAbatimento,
cpnd_Fornecedor,
cpnd_Valida
   

      FROM CP_NotaFiscalDetalhe
   
     WHERE cpnd_Fornecedor = @CodigoFornecedor
       AND cpnd_NotaFiscal = @NumeroNota
       AND cpnd_TipoNota   = @TipoNota
       AND cpnd_Pedido     = @Pedido

    ORDER BY cpnd_Parcela

END



