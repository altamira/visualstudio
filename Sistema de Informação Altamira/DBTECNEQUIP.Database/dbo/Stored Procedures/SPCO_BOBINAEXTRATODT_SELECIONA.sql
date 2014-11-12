
/****** Object:  Stored Procedure dbo.SPCO_BOBINAEXTRATODT_SELECIONA    Script Date: 23/10/2010 15:32:32 ******/


/****** Object:  Stored Procedure dbo.SPCO_BOBINAEXTRATODT_SELECIONA    Script Date: 25/08/1999 20:11:46 ******/
CREATE PROCEDURE SPCO_BOBINAEXTRATODT_SELECIONA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @Selecao          char(1)

AS

IF @Selecao = 'E' 

   BEGIN

     SELECT cohb_Codigo,
            coal_Descricao,
            coal_Unidade,
            cohb_Nota,
            cofc_Abreviado,
            cohb_Data,
            cohb_Quantidade,
            'Entrada' AuxTipo
            
         FROM CO_HistoricoBobina,
              CO_Almoxarifado,
              CO_Pedido,
              CO_Fornecedor              
                 
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
               AND cohb_Movimento = 'E'
               AND coal_Codigo = cohb_Codigo
               AND cope_Numero = cohb_Pedido
               AND cofc_Codigo = cope_Fornecedor

         ORDER BY cohb_Data

   END
   
ELSE

   BEGIN
   
   IF @Selecao = 'S'                        

      BEGIN

        SELECT cohb_Codigo,
               coal_Descricao,
               coal_Unidade,
               '' cohb_Nota,
               '' cofc_Abreviado,
               cohb_Data,
               cohb_Quantidade,
               'Saida' AuxTipo

         FROM CO_HistoricoBobina,
              CO_Almoxarifado
                 
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
               AND cohb_Movimento = 'S'
               AND coal_Codigo = cohb_Codigo

         ORDER BY cohb_Data
       
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


         SELECT cohb_Codigo,
                coal_Descricao,
                coal_Unidade,
                CASE cohb_Movimento
                  WHEN 'E' THEN cohb_Nota
                  WHEN 'S' THEN ''
                END cohb_Nota,
                CASE cohb_Movimento
                  WHEN 'E' THEN cofc_Abreviado
                  WHEN 'S' THEN ''
                END cofc_Abreviado,   
                cohb_Data,
                cohb_Quantidade,
                CASE cohb_Movimento
                  WHEN 'E' THEN  'Entrada'
                  WHEN 'S' THEN  'Saida'
                END AuxTipo 
         FROM CO_Almoxarifado,
              #PedidoFornecedor LEFT JOIN CO_HistoricoBobina on cope_Numero = cohb_Pedido
                 
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
               AND coal_Codigo = cohb_Codigo
    
         ORDER BY cohb_Data

      END

END



