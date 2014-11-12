
/****** Object:  Stored Procedure dbo.SPCO_CREDITO_RELATORIO    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CREDITO_RELATORIO    Script Date: 16/10/01 13:41:53 ******/
/****** Object:  Stored Procedure dbo.SPCO_CREDITO_RELATORIO    Script Date: 05/01/1999 11:03:42 ******/
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


