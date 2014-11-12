
/****** Object:  Stored Procedure dbo.SPCO_CONTACORRENTEFOR_CONSULTA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CONTACORRENTEFOR_CONSULTA    Script Date: 16/10/01 13:41:53 ******/
/****** Object:  Stored Procedure dbo.SPCO_CONTACORRENTEFOR_CONSULTA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_CONTACORRENTEFOR_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @CodigoFornecedor char(14)
   
AS


BEGIN


   SELECT coin_DataEntrada,
          coin_Nota,
          coin_Numero,
          coit_Produto,
          coit_Discriminacao,
          coit_Unidade,
          coin_Quantidade,
          coin_Valor,
          cope_Condicoes,
          cofc_Codigo,
          cofc_Nome       
     
     FROM CO_ItemNota,
          CO_ItemPedido,
          CO_Pedido,
          CO_Fornecedor

    WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
      
      AND coit_Item   = coin_Item
      AND coit_Numero = coin_Numero

      AND cope_Numero = coit_Numero
      
      AND cope_Fornecedor = cofc_Codigo

      AND cofc_Codigo = @CodigoFornecedor

    Order By coin_DataEntrada

END

