
/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_VISUALIZA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_VISUALIZA    Script Date: 16/10/01 13:41:46 ******/
/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_VISUALIZA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_BAIXAPEDIDO_VISUALIZA


AS


BEGIN
   
   SELECT cope_Status, 
          cope_Numero,
          cope_Data,
          cofc_Nome
     FROM CO_Pedido,
          CO_Fornecedor
    WHERE cope_Fornecedor = cofc_Codigo
      AND cope_Status <> 'T'

END


