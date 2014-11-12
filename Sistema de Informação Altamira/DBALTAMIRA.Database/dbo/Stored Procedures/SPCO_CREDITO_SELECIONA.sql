
/****** Object:  Stored Procedure dbo.SPCO_CREDITO_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_CREDITO_SELECIONA    Script Date: 25/08/1999 20:11:38 ******/
CREATE PROCEDURE SPCO_CREDITO_SELECIONA

    @DataInicial  smalldatetime,
    @DataFinal    smalldatetime

AS

       
BEGIN

   SELECT coin_Nota,
          coin_Numero,
          coin_DataNota,
          coin_DataEntrada,
          coin_valor * coin_Quantidade AuxTotal,
          
          CASE coin_Credito 
            WHEN '1' THEN 0
            WHEN '2' THEN 0
            WHEN '3' THEN (coin_valor * coin_Quantidade) * CONVERT(int, coit_Ipi) / 100
            WHEN '4' THEN (coin_valor * coin_Quantidade) * CONVERT(int, coit_Ipi) / 100
            WHEN '5' THEN (coin_valor * coin_Quantidade) / 2 * 0.1
            WHEN '6' THEN (coin_valor * coin_Quantidade) / 2 * 0.1
          END AuxIPI,
          
          CASE coin_Credito 
            WHEN '1' THEN 0
            WHEN '2' THEN (coin_valor * coin_Quantidade) * CONVERT(int, coit_Icms) / 100
            WHEN '3' THEN 0
            WHEN '4' THEN (coin_valor * coin_Quantidade) * CONVERT(int, coit_Icms) / 100
            WHEN '5' THEN 0
            WHEN '6' THEN (coin_valor * coin_Quantidade) * CONVERT(int, coit_Icms) / 100
          END AuxICMS

     INTO #ValorCredito

     FROM CO_ItemNota,
          CO_ItemPedido
    
    WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal

      AND coit_Numero = coin_Numero
      AND coit_Item   = coin_Item

   SELECT cofc_Nome,
          coin_Nota, 
          coin_DataNota,
          coin_DataEntrada,
          Sum(AuxTotal) AuxTotal,
          Sum(AuxIPI) AuxIPI,
          Sum(AuxICMS) AuxICMS

     FROM #ValorCredito,
          CO_Fornecedor,
          CO_Pedido
    
    WHERE cope_Numero = coin_Numero

      AND cofc_Codigo = cope_Fornecedor

    GROUP BY cofc_Nome,
             coin_Nota,
             coin_DataNota,
             coin_DataEntrada

   ORDER BY coin_DataEntrada

END            


