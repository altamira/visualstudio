
/****** Object:  Stored Procedure dbo.SPCP_OPSINALPEDREI_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_OPSINALPEDREI_RELATORIO    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_OPSINALPEDREI_RELATORIO

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

