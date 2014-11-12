
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_VISUALIZA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_VISUALIZA    Script Date: 25/08/1999 20:11:39 ******/
CREATE PROCEDURE SPCO_PEDIDO_VISUALIZA

AS

BEGIN

   SELECT cope_Status 'Baixa',
          cope_Numero 'Número',
          cope_Data   'Data do Pedido',
          cofc_Nome   'Fornecedor'
     FROM CO_Pedido,
          CO_Fornecedor
    WHERE cope_Fornecedor = cofc_Codigo
      AND cope_Status <> 'T'
    
END

