
/****** Object:  Stored Procedure dbo.SPCO_CHAPAPENDENTE_SELECIONA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CHAPAPENDENTE_SELECIONA    Script Date: 16/10/01 13:41:53 ******/
/****** Object:  Stored Procedure dbo.SPCO_CHAPAPENDENTE_SELECIONA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_CHAPAPENDENTE_SELECIONA

AS

BEGIN

   SELECT coin_Numero cosq_Numero,
          coin_Item   cosq_Item,           
          SUM(coin_Quantidade) cosq_Quantidade 
     INTO #SomaQuantidade
     FROM CO_ItemNota
       
    
 GROUP BY coin_Numero, coin_Item


   SELECT coin_Item codc_Item,
          coin_Numero codc_Numero,
          codc_Descricao
    
     INTO #DescricaoCredito
    
     FROM CO_ItemNota,
          CO_DescricaoCredito
    
    WHERE coin_Credito = codc_Codigo

   
   SELECT coit_Numero cota_Numero,
          coit_Item   cota_Item,  
          coit_Quantidade - ISNULL(cosq_Quantidade, 0) cota_Total
     
     INTO #Total
     
     FROM #SomaQuantidade LEFT JOIN          CO_ItemPedido ON cosq_Numero = coit_Numero
      AND cosq_Item   = coit_Item



   SELECT DISTINCT  cope_Data,    
                    coit_Numero,
                    cofc_Nome,
                    coit_Item,
                    coit_Produto,
                    coit_Discriminacao,
                    cota_Total coit_Total,
                    coit_Preco
                         
     FROM CO_ItemPedido LEFT JOIN CO_ItemNota ON COIN_NUMERO=COIT_NUMERO AND COIN_ITEM = COIT_ITEM 
LEFT JOIN #SomaQuantidade ON cosq_Numero = coit_numero and cosq_Item = coit_Item
LEFT JOIN #DescricaoCredito ON  codc_Numero = coit_Numero      AND codc_Item   = coit_Item ,
       #Total,
          CO_Pedido,
          CO_Fornecedor

    WHERE cope_Numero = coit_Numero
      AND cope_Status <> 'T'

      AND cofc_Codigo = cope_Fornecedor
          
      AND SUBSTRING(coit_Produto, 1, 3) = 'WCB'

      AND cota_Numero = coit_Numero
      AND cota_Item   = coit_Item

      AND cota_Total > 0

      
      ORDER BY coit_Numero, coit_Item



END  
   
  
   
   
   
   
   
   
   
   
   
   
   
   
   
 




