
/****** Object:  Stored Procedure dbo.SPCO_CONJUNTO_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_CONJUNTO_CONSULTA    Script Date: 25/08/1999 20:11:38 ******/
CREATE PROCEDURE SPCO_CONJUNTO_CONSULTA 

   @DataInicial    smalldatetime,
   @DataFinal      smalldatetime,
   @CodigoProduto  char(9)
   
AS

BEGIN

   SELECT coin_DataEntrada,
          cofc_Abreviado,
          cope_Numero,
          coit_Produto,
          coit_Discriminacao,
          coit_Unidade,
          coin_Quantidade,
          coin_Valor,
          (coin_Quantidade * coin_Valor) AuxValorTotal,
          cope_Imobilizado

     FROM CO_ItemNota,
          CO_Fornecedor,
          CO_Pedido,
          CO_ItemPedido
          
    WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
      
      AND coit_Item   = coin_Item
      AND coit_Numero = coin_Numero

      AND cope_Numero = coit_Numero

      AND cofc_Codigo = cope_Fornecedor

      AND cope_Imobilizado = @CodigoProduto

END

