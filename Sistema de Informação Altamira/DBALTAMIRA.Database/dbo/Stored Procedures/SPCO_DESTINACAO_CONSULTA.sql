
/****** Object:  Stored Procedure dbo.SPCO_DESTINACAO_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCO_DESTINACAO_CONSULTA    Script Date: 25/08/1999 20:11:57 ******/
CREATE PROCEDURE SPCO_DESTINACAO_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime

AS
	
   DECLARE @TotalAco           money,
           @TotalConstrucao    money,
           @TotalConsumo       money,
           @TotalEscritorio    money,
           @TotalFerramentas   money,
           @TotalParafusos     money,
           @TotalImobilizado   money,
           @TotalMateriaPrima  money,
           @TotalTinta         money,
           @TotalServico       money

BEGIN

   -- AÇO

   SELECT @TotalAco = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'A'

   -- CONSTRUÇÃO

   SELECT @TotalConstrucao = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'C'
   -- CONSUMO

   SELECT @TotalConsumo = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'O'          
             
   -- ESCRITÓRIO

   SELECT @TotalEscritorio = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'E'     
    
   -- FERRAMENTAS

   SELECT @TotalFerramentas = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'F'     

   -- PARAFUSOS

   SELECT @TotalParafusos = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'P'    

   -- IMOBILIZADO

   SELECT @TotalImobilizado = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'I'   

   -- MATÉRIA-PRIMA

   SELECT @TotalMateriaPrima = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'M'   

   -- SERVICO

   SELECT @TotalServico = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'S' 

   -- TINTA

   SELECT @TotalTinta = SUM(coin_Valor * coin_Quantidade)
      FROM CO_ItemNota,
           CO_ItemPedido
         WHERE coin_DataEntrada BETWEEN @DataInicial AND @DataFinal
             AND coin_Numero = coit_Numero
             AND coin_Item = coit_Item
             AND coit_Destinacao = 'T' 


   CREATE TABLE #TabDestinacao(Descricao varchar(30),
                               Total     money)

   INSERT INTO #TabDestinacao Values ('Aço', ISNULL(@TotalAco, 0))
   INSERT INTO #TabDestinacao Values ('Construção', ISNULL(@TotalConstrucao, 0))
   INSERT INTO #TabDestinacao Values ('Consumo', ISNULL(@TotalConsumo, 0))
   INSERT INTO #TabDestinacao Values ('Escritório', ISNULL(@TotalEscritorio, 0))
   INSERT INTO #TabDestinacao Values ('Ferramentas', ISNULL(@TotalFerramentas, 0))
   INSERT INTO #TabDestinacao Values ('Parafusos', ISNULL(@TotalParafusos, 0))
   INSERT INTO #TabDestinacao Values ('Imobilizado', ISNULL(@TotalImobilizado, 0))
   INSERT INTO #TabDestinacao Values ('Matéria-Prima', ISNULL(@TotalMateriaPrima, 0))
   INSERT INTO #TabDestinacao Values ('Serviço', ISNULL(@TotalServico, 0))
   INSERT INTO #TabDestinacao Values ('Tinta', ISNULL(@TotalTinta, 0))

   SELECT * FROM #TabDestinacao
      ORDER BY Descricao

END


