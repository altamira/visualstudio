
/****** Object:  Stored Procedure dbo.SPCO_CREDITO_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_CREDITO_RELATORIO    Script Date: 25/08/1999 20:11:57 ******/
CREATE PROCEDURE SPCO_CREDITO_RELATORIO

@DataInicial  smalldatetime,
@DataFinal    smalldatetime

AS

    
BEGIN

   
   SELECT cofc_Nome,
          coin_DataEntrada,
          coin_DataNota,
          coin_Nota,
          coin_Numero,
          coin_Item,
          coin_Quantidade,
          coin_Credito,
          coin_Valor,
          coit_ipi,
          coit_icms
        
     FROM CO_Fornecedor,
          CO_Pedido,
          CO_ItemNota,
          CO_ItemPedido

    WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
      AND cope_Numero = coin_Numero
      AND cofc_Codigo = cope_Fornecedor
      AND coit_Numero = coin_Numero
      AND coit_Item   = coin_Item
      
    ORDER BY coin_DataEntrada
END            


