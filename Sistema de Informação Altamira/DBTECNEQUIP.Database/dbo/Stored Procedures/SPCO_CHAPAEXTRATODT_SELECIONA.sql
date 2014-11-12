
/****** Object:  Stored Procedure dbo.SPCO_CHAPAEXTRATODT_SELECIONA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CHAPAEXTRATODT_SELECIONA    Script Date: 16/10/01 13:41:46 ******/
/****** Object:  Stored Procedure dbo.SPCO_CHAPAEXTRATODT_SELECIONA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_CHAPAEXTRATODT_SELECIONA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @Selecao          char(1)

AS

IF @Selecao = 'E' 

   BEGIN

     SELECT cohc_Codigo,
            coal_Descricao,
            coal_Unidade,
            cohc_Nota,
            cofc_Abreviado,
            cohc_Data,
            cohc_Quantidade,
            'Entrada' AuxTipo
            
         FROM CO_HistoricoChapa,
              CO_Almoxarifado,
              CO_Pedido,
              CO_Fornecedor              
                 
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
               AND cohc_Movimento = 'E'
               AND coal_Codigo = cohc_Codigo
               AND cope_Numero = cohc_Pedido
               AND cofc_Codigo = cope_Fornecedor

         ORDER BY cohc_Data

   END
   
ELSE

   BEGIN
   
   IF @Selecao = 'S'                        

      BEGIN

        SELECT cohc_Codigo,
               coal_Descricao,
               coal_Unidade,
               '' cohc_Nota,
               '' cofc_Abreviado,
               cohc_Data,
               cohc_Quantidade,
               'Saida' AuxTipo

         FROM CO_HistoricoChapa,
              CO_Almoxarifado
                 
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
               AND cohc_Movimento = 'S'
               AND coal_Codigo = cohc_Codigo

         ORDER BY cohc_Data
       
      END

    ELSE

      BEGIN

         SELECT cofc_Codigo,
                cofc_Abreviado,
                cope_Numero,
                cope_Fornecedor
            INTO #PedidoFornecedor
              FROM CO_Fornecedor,
                   CO_Pedido
               WHERE cofc_Codigo = cope_Fornecedor     


         SELECT cohc_Codigo,
                coal_Descricao,
                coal_Unidade,
                CASE cohc_Movimento
                  WHEN 'E' THEN cohc_Nota
                  WHEN 'S' THEN ''
                END cohc_Nota,
                CASE cohc_Movimento
                  WHEN 'E' THEN cofc_Abreviado
                  WHEN 'S' THEN ''
                END cofc_Abreviado,   
                cohc_Data,
                cohc_Quantidade,
                CASE cohc_Movimento
                  WHEN 'E' THEN  'Entrada'
                  WHEN 'S' THEN  'Saida'
                END AuxTipo 
         FROM CO_HistoricoChapa LEFT JOIN #PedidoFornecedor ON COPE_NUMERO = COHC_PEDIDO,
              CO_Almoxarifado
              
                 
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
               AND coal_Codigo = cohc_Codigo
    
         ORDER BY cohc_Data

      END

END


