
/****** Object:  Stored Procedure dbo.SPCO_CHAPAEXTRATORS_SELECIONA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_CHAPAEXTRATORS_SELECIONA    Script Date: 16/10/01 13:41:44 ******/
/****** Object:  Stored Procedure dbo.SPCO_CHAPAEXTRATORS_SELECIONA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_CHAPAEXTRATORS_SELECIONA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime,
   @Selecao          char(1)

AS

IF @Selecao = 'E' 

   BEGIN

     SELECT cohc_Codigo,
            coal_Descricao,
            coal_Unidade,
            SUM(cohc_Quantidade) AuxEntrada,
            0 AuxSaida,
            0 AuxDiferenca,
            'Entrada' AuxTipo
            
         FROM CO_HistoricoChapa,
              CO_Almoxarifado
                      
                 
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
               AND cohc_Movimento = 'E'
               AND coal_Codigo = cohc_Codigo
        
         GROUP BY cohc_Codigo, 
                  coal_Descricao,
                  coal_Unidade
                  
         ORDER BY cohc_Codigo

   END
   
ELSE

   BEGIN
   
   IF @Selecao = 'S'                        

      BEGIN

        SELECT cohc_Codigo,
               coal_Descricao,
               coal_Unidade,
               0 AuxEntrada,
               SUM(cohc_Quantidade) AuxSaida,
               0 AuxDiferenca,
               'Saida' AuxTipo

         FROM CO_HistoricoChapa,
              CO_Almoxarifado
                 
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
               AND cohc_Movimento = 'S'
               AND coal_Codigo = cohc_Codigo

          GROUP BY cohc_Codigo, 
                  coal_Descricao,
                  coal_Unidade        

         ORDER BY cohc_Codigo
       
      END

    ELSE

      BEGIN

      SELECT cohc_Codigo,
             coal_Descricao,
             coal_Unidade,
             CASE cohc_Movimento
               WHEN 'E' THEN  Sum(Round(cohc_Quantidade, 3))
               WHEN 'S' THEN  0 
             END AuxEntrada

      INTO #ResumidoEntrada

      FROM CO_HistoricoChapa,
           CO_Almoxarifado
        
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
        AND coal_Codigo = cohc_Codigo
        AND cohc_movimento = 'E'


      GROUP BY cohc_Codigo, 
               coal_Descricao,
               coal_Unidade,        
               cohc_Movimento

      ORDER BY cohc_Codigo

      SELECT cohc_Codigo,
             coal_Descricao,
             coal_Unidade,
             CASE cohc_Movimento
               WHEN 'E' THEN  0
               WHEN 'S' THEN  Sum(Round(cohc_Quantidade, 3)) 
             END AuxSaida

        INTO #ResumidoSaida


        FROM CO_HistoricoChapa,
             CO_Almoxarifado
        
         WHERE cohc_Data BETWEEN @DataInicial AND @DataFinal
         AND coal_Codigo = cohc_Codigo
         AND cohc_movimento = 'S'


      GROUP BY cohc_Codigo, 
               coal_Descricao,
               coal_Unidade,        
               cohc_Movimento

      ORDER BY cohc_Codigo
	


	    SELECT rs.cohc_Codigo,
              rs.coal_Descricao,
              rs.coal_Unidade,
	           ISNULL(re.AuxEntrada, 0) AuxEntrada,
	           rs.AuxSaida,
		        isnull(re.AuxEntrada, 0) - isnull(rs.AuxSaida, 0)  AuxDiferenca
         FROM #ResumidoEntrada re LEFT JOIN               #ResumidoSaida   rs ON re.cohc_Codigo  = rs.cohc_Codigo

     	  UNION 
        
        SELECT re.cohc_Codigo,
              re.coal_Descricao,
              re.coal_Unidade,
	           re.AuxEntrada,
	           ISNULL(rs.AuxSaida,0) AuxSaida,
		        isnull(re.AuxEntrada, 0) - isnull(rs.AuxSaida, 0)  AuxDiferenca 
         FROM #ResumidoEntrada re LEFT JOIN #ResumidoSaida   rs ON re.cohc_Codigo  = rs.cohc_Codigo


      END

   END




