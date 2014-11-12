
/****** Object:  Stored Procedure dbo.SPCO_BOBINAEXTRATORS_SELECIONA    Script Date: 23/10/2010 15:32:32 ******/

/****** Object:  Stored Procedure dbo.SPCO_BOBINAEXTRATORS_SELECIONA    Script Date: 16/10/01 13:41:46 ******/
/****** Object:  Stored Procedure dbo.SPCO_BOBINAEXTRATORS_SELECIONA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_BOBINAEXTRATORS_SELECIONA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @Selecao          char(1)

AS

IF @Selecao = 'E' 

   BEGIN

     SELECT cohb_Codigo,
            coal_Descricao,
            coal_Unidade,
            SUM(cohb_Quantidade) AuxEntrada,
            0 AuxSaida,
            0 AuxDiferenca,
            'Entrada' AuxTipo
            
         FROM CO_HistoricoBobina,
              CO_Almoxarifado
                      
                 
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
               AND cohb_Movimento = 'E'
               AND coal_Codigo = cohb_Codigo
        
         GROUP BY cohb_Codigo, 
                  coal_Descricao,
                  coal_Unidade
                  
         ORDER BY cohb_Codigo

   END
   
ELSE

   BEGIN
   
   IF @Selecao = 'S'                        

      BEGIN

        SELECT cohb_Codigo,
               coal_Descricao,
               coal_Unidade,
               0 AuxEntrada,
               SUM(cohb_Quantidade) AuxSaida,
               0 AuxDiferenca,
               'Saida' AuxTipo

         FROM CO_HistoricoBobina,
              CO_Almoxarifado
                 
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
               AND cohb_Movimento = 'S'
               AND coal_Codigo = cohb_Codigo

          GROUP BY cohb_Codigo, 
                  coal_Descricao,
                  coal_Unidade        

         ORDER BY cohb_Codigo
       
      END

    ELSE

      BEGIN

      SELECT cohb_Codigo,
             coal_Descricao,
             coal_Unidade,
             CASE cohb_Movimento
               WHEN 'E' THEN  Sum(cohb_Quantidade)
               WHEN 'S' THEN  0 
             END AuxEntrada

      INTO #ResumidoEntrada

      FROM CO_HistoricoBobina,
           CO_Almoxarifado
        
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
        AND coal_Codigo = cohb_Codigo
        AND cohb_movimento = 'E'


      GROUP BY cohb_Codigo, 
               coal_Descricao,
               coal_Unidade,        
               cohb_Movimento

      ORDER BY cohb_Codigo

      SELECT cohb_Codigo,
             coal_Descricao,
             coal_Unidade,
             CASE cohb_Movimento
               WHEN 'E' THEN  0
               WHEN 'S' THEN  Sum(cohb_Quantidade) 
             END AuxSaida

        INTO #ResumidoSaida


        FROM CO_HistoricoBobina,
             CO_Almoxarifado
        
         WHERE cohb_Data BETWEEN @DataInicial AND @DataFinal
         AND coal_Codigo = cohb_Codigo
         AND cohb_movimento = 'S'


      GROUP BY cohb_Codigo, 
               coal_Descricao,
               coal_Unidade,        
               cohb_Movimento

      ORDER BY cohb_Codigo
	


	    SELECT rs.cohb_Codigo,
              rs.coal_Descricao,
              rs.coal_Unidade,
	           ISNULL(re.AuxEntrada, 0) AuxEntrada,
	           rs.AuxSaida,
		        isnull(re.AuxEntrada, 0) - isnull(rs.AuxSaida, 0)  AuxDiferenca
         FROM #ResumidoEntrada re LEFT JOIN              #ResumidoSaida   rs ON re.cohb_Codigo  = rs.cohb_Codigo

     	  UNION 
        
        SELECT re.cohb_Codigo,
              re.coal_Descricao,
              re.coal_Unidade,
	           re.AuxEntrada,
	           ISNULL(rs.AuxSaida,0) AuxSaida,
		        isnull(re.AuxEntrada, 0) - isnull(rs.AuxSaida, 0)  AuxDiferenca 
         FROM #ResumidoEntrada re LEFT JOIN          #ResumidoSaida   rs ON  re.cohb_Codigo  = rs.cohb_Codigo


      END

   END



