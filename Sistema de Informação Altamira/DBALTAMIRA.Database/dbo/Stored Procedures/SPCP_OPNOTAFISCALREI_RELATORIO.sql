
/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALREI_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALREI_RELATORIO    Script Date: 25/08/1999 20:11:39 ******/
CREATE PROCEDURE SPCP_OPNOTAFISCALREI_RELATORIO

    @NumeroOP  int

AS

BEGIN

       SELECT cofc_Nome,
              cofc_DDDTelefone,
              cofc_Telefone,
              cofc_DDDFax,
              cofc_Fax,
	cofc_Contato,
              cpnf_NotaFiscal, 
              cpnf_Fornecedor,
              cpnf_DataEntrada,
              cpnf_ValorTotal,
              cpnf_Parcelas,
	 cpnd_Pedido,
              cpnd_Parcela,
              cpnd_DataVencimento,
              cpnd_DataProrrogacao,
              cpnd_Observacao,
              cpnd_Valor,
              cpnd_ValorMulta,
              cpnd_ValorDesconto,
              cpnd_ValorTotal,
              cpnd_Duplicata,
              cpnd_NumeroOP,
              cpnd_DataOP

           FROM  CO_Fornecedor, 
                 CP_NotaFiscal,
                 CP_NotaFiscalDetalhe

           WHERE cpnd_NumeroOP = @NumeroOP
           
             AND cpnf_Fornecedor = cpnd_Fornecedor
             AND cpnf_NotaFiscal = cpnd_NotaFiscal
             
             AND cpnf_TipoNota = cpnd_TipoNota
             
             AND cofc_Codigo = cpnf_Fornecedor

    

END	








