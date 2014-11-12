
/****** Object:  Stored Procedure dbo.SPCP_CONTACORRENTEIMP_CONSULTA    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_CONTACORRENTEIMP_CONSULTA    Script Date: 25/08/1999 20:11:47 ******/
CREATE PROCEDURE SPCP_CONTACORRENTEIMP_CONSULTA

@DataInicial      smalldatetime,
@DataFinal        smalldatetime,
@Imposto          smallint

AS

BEGIN

   -- Cria Tabela temporária para o detalhe

   CREATE TABLE #TabConta  ( Vencimento    smalldatetime null,
                             Periodo       varchar(30)   null,
                             Parcela       smallint      null,
                             Valor         money         null,
                             Pagamento     smalldatetime null,
                             Observacao    varchar(50)   null )


   -- Insere os dados na tabela temporária
   INSERT INTO #TabConta ( Vencimento,
                           Periodo,
                           Parcela,
                           Valor,
                           Pagamento,
                           Observacao )


    SELECT  cpdd_DataVencimento,
            cpdi_Periodo,
            cpdd_Parcela,
            cpdd_ValorTotal,
            cpdd_DataPagamento,
            cpdd_Observacao

        FROM  CP_DespesaImposto,
              CP_DespesaImpostoDetalhe

           WHERE  cpdd_DataVencimento BETWEEN @DataInicial AND @DataFinal
             AND  cpdd_DataProrrogacao IS NULL
             AND  cpdi_Sequencia = cpdd_Sequencia
             AND  cpdi_TipoConta = 'I'
             AND  cpdi_CodigoConta = @Imposto
             
       
     -- Insere os dados na tabela temporária
   INSERT INTO #TabConta ( Vencimento,
                           Periodo,
                           Parcela,
                           Valor,
                           Pagamento,
                           Observacao )


    SELECT  cpdd_DataProrrogacao,
            cpdi_Periodo,
            cpdd_Parcela,
            cpdd_ValorTotal,
            cpdd_DataPagamento,
            cpdd_Observacao

        FROM  CP_DespesaImposto,
              CP_DespesaImpostoDetalhe

           WHERE  cpdd_DataProrrogacao BETWEEN @DataInicial AND @DataFinal
             AND  cpdi_Sequencia = cpdd_Sequencia
             AND  cpdi_TipoConta = 'I'
             AND  cpdi_CodigoConta = @Imposto  
             
             
           
          SELECT * FROM #TabConta

             ORDER BY Vencimento


END




