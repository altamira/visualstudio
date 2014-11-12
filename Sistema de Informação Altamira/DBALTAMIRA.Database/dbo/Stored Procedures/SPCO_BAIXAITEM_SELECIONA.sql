
/****** Object:  Stored Procedure dbo.SPCO_BAIXAITEM_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCO_BAIXAITEM_SELECIONA    Script Date: 25/08/1999 20:11:30 ******/
CREATE PROCEDURE SPCO_BAIXAITEM_SELECIONA


   @NumeroPedido   int   -- Número do pedido

AS

BEGIN

   SELECT coin_Numero cosq_Numero,
          coin_Item   cosq_Item,           
          SUM(coin_Quantidade) cosq_Quantidade 
     INTO #SomaQuantidade
     FROM CO_ItemNota
    
    WHERE coin_Numero = @NumeroPedido

 GROUP BY coin_Numero, coin_Item


   SELECT coin_Item codc_Item,
          coin_Numero codc_Numero,
          codc_Descricao
    
     INTO #DescricaoCredito
    
     FROM CO_ItemNota,
          CO_DescricaoCredito
    
    WHERE coin_Credito = codc_Codigo



   SELECT DISTINCT  coit_Numero,
                    coit_Quantidade,
                    coit_Produto,
                    coit_Discriminacao,
                    coit_Item,
                    coit_Unidade,
                    ISNULL(cosq_Quantidade, 0) cosq_Quantidade,
                    coit_Quantidade - ISNULL(cosq_Quantidade, 0) coit_Total,
                    coit_PrecoUnit,
                    codc_Descricao,
                    CASE ISNULL(codc_Descricao, '0')
                      WHEN '0' THEN 'N'
                      ELSE 'S'
                     END codc_PossuiDesc
                    
     FROM CO_ItemPedido as pedido1 LEFT JOIN     CO_ItemNota ON coin_Numero = pedido1.coit_Numero      
AND coin_Item   = pedido1.coit_Item left join #DescricaoCredito  on codc_Numero = pedido1.coit_Numero     
AND codc_Item   = pedido1.coit_Item  left join  #SomaQuantidade on cosq_Numero = pedido1.coit_Numero     
 AND cosq_Item   = pedido1.coit_Item

    WHERE coit_Numero = @NumeroPedido
   
      ORDER BY coit_Numero, coit_Item



drop table #DescricaoCredito
drop table #SomaQuantidade


END




