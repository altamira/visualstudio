
/****** Object:  Stored Procedure dbo.SPCP_OPSINALREI_RELATORIO    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_OPSINALREI_RELATORIO    Script Date: 16/10/01 13:41:48 ******/
/****** Object:  Stored Procedure dbo.SPCP_OPSINALREI_RELATORIO    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_OPSINALREI_RELATORIO

    @NumeroOP   int

AS

BEGIN

       SELECT cofc_Nome,
              cofc_DDDTelefone,
              cofc_Telefone,
              cofc_DDDFax,
              cofc_Fax,
              cofc_Codigo,
              cpsp_Pedido,
              cpsp_DataVencimento,
              cpsp_Observacao,
              cpsp_Valor,
              cpsp_NumeroOP,
              cpsp_DataOP

             FROM  CO_Fornecedor, 
                   CO_Pedido,
                   CP_SinalPedido

           WHERE cpsp_NumeroOP = @NumeroOP
             AND cope_Numero = cpsp_Pedido
             AND cofc_Codigo = cope_Fornecedor
              

END	

