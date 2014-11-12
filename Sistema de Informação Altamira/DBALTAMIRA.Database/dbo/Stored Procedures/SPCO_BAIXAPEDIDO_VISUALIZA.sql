
/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_VISUALIZA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_BAIXAPEDIDO_VISUALIZA    Script Date: 25/08/1999 20:11:46 ******/
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

        ORDER BY cope_Numero

END


