
/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALREI_RELATORIO    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALREI_RELATORIO    Script Date: 16/10/01 13:41:52 ******/
/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALREI_RELATORIO    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_OPNOTAFISCALREI_RELATORIO

    @NumeroOP   int

AS

BEGIN

       SELECT cofc_Nome,
              cofc_DDDTelefone,
              cofc_Telefone,
              cofc_DDDFax,
              cofc_Fax,
              cpnf_NotaFiscal, 
              cpnf_Fornecedor,
              cpnf_DataEntrada,
              cpnf_ValorTotal,
              cpnf_Parcelas,
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

