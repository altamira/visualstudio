
/****** Object:  Stored Procedure dbo.SPCP_OPIMPRIME_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPCP_OPIMPRIME_RELATORIO    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_OPIMPRIME_RELATORIO
        	@NotaFiscal   	char(6),
        	@Pedido       	int

AS

BEGIN

SELECT cope_Data, cope_Fornecedor, cope_Observacao, 
   cpnf_Notafiscal, cpnf_Pedido, cpnf_DataEntrada, 
   cpnf_ValorTotal, cpnf_Parcelas, cpnd_Parcela, 
   cpnd_DataVencimento, cpnd_DataProrrogacao, cpnd_Valor, 
   cpnd_ValorDesconto, cpnd_Observacao, 
   cpnd_ObservacãoAbatimento, 
   cpnd_ObservaçãoProrrogação,cpnd_ValorMulta
FROM CO_Pedido, CP_NotaFiscal, CP_NotaFiscalDetalhe
WHERE cpnd_Fornecedor = cpnf_Fornecedor AND 
   cpnd_Notafiscal = cpnf_NotaFiscal AND 
   cpnd_TipoNota = cpnf_TipoNota AND 
   cpnd_Pedido = cpnf_Pedido AND 
   cpnf_Pedido = cope_Numero AND 
   cpnf_Fornecedor = cope_Fornecedor AND 
   cpnf_Notafiscal = @NotaFiscal AND cpnf_Pedido = @Pedido
ORDER BY cpnf_notafiscal, cpnd_Parcela
END







