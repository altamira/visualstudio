
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_VISUALIZA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_VISUALIZA    Script Date: 16/10/01 13:41:47 ******/
/****** Object:  Stored Procedure dbo.SPCO_PEDIDO_VISUALIZA    Script Date: 05/01/1999 11:03:43 ******/
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

