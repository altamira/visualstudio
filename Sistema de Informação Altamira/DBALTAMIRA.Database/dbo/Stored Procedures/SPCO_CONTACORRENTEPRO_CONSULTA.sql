
/****** Object:  Stored Procedure dbo.SPCO_CONTACORRENTEPRO_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_CONTACORRENTEPRO_CONSULTA    Script Date: 25/08/1999 20:11:57 ******/
CREATE PROCEDURE SPCO_CONTACORRENTEPRO_CONSULTA 

   @DataInicial    smalldatetime,
   @DataFinal      smalldatetime,
   @CodigoProduto  char(9)
   
AS

BEGIN

   SELECT coin_DataEntrada,
          cofc_Nome,
          coin_Nota,
          cope_Numero,
          coit_Produto,
          coit_Discriminacao,
          coin_Quantidade,
          coin_Valor,
          cope_Condicoes

     FROM CO_ItemNota,
          CO_Fornecedor,
          CO_Pedido,
          CO_ItemPedido
          
    WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
      
      AND coit_Item   = coin_Item
      AND coit_Numero = coin_Numero
      AND cope_Numero = coit_Numero
      AND cofc_Codigo = cope_Fornecedor
      AND coit_Produto = @CodigoProduto

     Order By coin_DataEntrada

END

