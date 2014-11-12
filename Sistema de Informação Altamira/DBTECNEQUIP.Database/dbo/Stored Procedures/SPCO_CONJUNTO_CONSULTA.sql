
/****** Object:  Stored Procedure dbo.SPCO_CONJUNTO_CONSULTA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CONJUNTO_CONSULTA    Script Date: 16/10/01 13:41:53 ******/
/****** Object:  Stored Procedure dbo.SPCO_CONJUNTO_CONSULTA    Script Date: 05/01/1999 11:03:42 ******/
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

