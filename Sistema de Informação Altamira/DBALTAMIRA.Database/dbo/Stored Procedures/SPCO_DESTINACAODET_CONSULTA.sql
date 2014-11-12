
/****** Object:  Stored Procedure dbo.SPCO_DESTINACAODET_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_DESTINACAODET_CONSULTA    Script Date: 25/08/1999 20:11:57 ******/
CREATE PROCEDURE SPCO_DESTINACAODET_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @TipoDestinacao   char(1)

AS
	
BEGIN

   SELECT coin_DataEntrada,
          coin_Nota, 
          coin_Numero,
          coit_Produto,
          coit_Discriminacao,
          coit_Unidade,
          coin_Valor,
          coin_Quantidade,
          coit_Destinacao 
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = @TipoDestinacao
      Order by coit_Produto,coin_DataEntrada
END



