
/****** Object:  Stored Procedure dbo.SPCO_CONSULTAPRODFORN_SELECAO    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CONSULTAPRODFORN_SELECAO    Script Date: 16/10/01 13:41:53 ******/
/****** Object:  Stored Procedure dbo.SPCO_CONSULTAPRODFORN_SELECAO    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_CONSULTAPRODFORN_SELECAO


   @CodigoFornecedor  char(14)


AS


BEGIN
	
   SELECT cofc_nome, 
          coin_Nota,
          coin_DataNota,
          coit_numero,
          coit_produto,
          coit_discriminacao,
          coit_unidade,
          coin_quantidade,
          coin_valor,
          cope_condicoes,
          cope_reajuste

     FROM CO_Fornecedor,
          CO_ItemPedido,
          CO_ItemNota,
          CO_Pedido

    WHERE cope_Fornecedor = cofc_codigo
      AND coin_Numero = cope_Numero 
      AND coit_Item = coin_Item
      AND coit_Numero = coin_Numero

 ORDER BY coin_DataNota DESC
   

END

