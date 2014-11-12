
/****** Object:  Stored Procedure dbo.SPCP_CONSCOPIACHEQUEN_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_CONSCOPIACHEQUEN_CONSULTA    Script Date: 25/08/1999 20:11:53 ******/
CREATE PROCEDURE SPCP_CONSCOPIACHEQUEN_CONSULTA

    @DataInicial    smalldatetime,
    @DataFinal      smalldatetime

AS


BEGIN

 -- Cria tabela para colocação dos dados para a consulta e relatorio
    CREATE TABLE #TabConsulta (Numero int null,
                               DataPagamento smalldatetime null,
                               Referencia char(40) null,
                               NotaFiscal char(6) null,
                               Periodo  char(30) null,
                               NumeroCheque char(15) null,
                               Banco char(3) null,
                               Valor money null)

 -- Insere Despesa/Imposto

    BEGIN

       INSERT INTO #TabConsulta (Numero,
                                 DataPagamento,
                                 Referencia,
                                 Periodo,
                                 NumeroCheque,
                                 Banco,
                                 Valor)


            SELECT cpdd_CopiaCheque,
                   cpdd_DataPagamento,
                   cpde_Descricao,
                   cpdi_Periodo,
                   cpdd_NumeroCheque,
                   cpdd_BancoCheque,
                   cpdd_Valortotal

              FROM CP_DespesaImpostoDetalhe,
                   CP_DespesaImposto,
                   CP_Descricao

             WHERE cpdd_DataPagamento Between @DataInicial AND @DataFinal
               AND cpdi_Sequencia = cpdd_Sequencia
               AND cpde_Codigo = cpdi_CodigoConta
               AND cpde_Tipo   = cpdi_TipoConta

    
   END

  -- Insere sinal de pedido

   BEGIN

            INSERT INTO #TabConsulta (Numero,
                                      DataPagamento,
                                      Referencia,
                                      NotaFiscal,
                                      Periodo,
                                      NumeroCheque,
                                      Banco,
                                      Valor)


                SELECT cpsp_CopiaCheque,
                       cpsp_DataPagamento,
                       cofc_Nome,
                       'Sinal',
                       '-----',
                       cpsp_NumeroCheque,
                       cpsp_BancoCheque,
                       cpsp_Valor
          
                  FROM CP_SinalPedido,
                       CO_Pedido,
                       CO_Fornecedor

                 WHERE cpsp_DataPagamento Between @DataInicial AND @DataFinal
                   AND cope_Numero = cpsp_Pedido
                   AND cofc_Codigo = cope_Fornecedor

   END

   -- Insere Nota Fiscal    
          
   BEGIN

          INSERT INTO #TabConsulta (Numero,
                                    DataPagamento,
                                    Referencia,
                                    NotaFiscal,
                                    Periodo,
                                    NumeroCheque,
                                    Banco,
                                    Valor)


                SELECT cpnd_CopiaCheque,
                       cpnd_DataPagamento,
                       cofc_Nome,
                       cpnd_NotaFiscal,
                       cpnd_Duplicata,
                       cpnd_NumeroCheque,
                       cpnd_BancoCheque,
                       cpnd_ValorTotal
          
                  FROM CP_NotaFiscalDetalhe,
                       CO_Fornecedor

                 WHERE cpnd_DataPagamento Between @DataInicial AND @DataFinal
                   AND cpnd_Fornecedor = cofc_Codigo
                                                                           
 
   END

        
    SELECT * FROM #TabConsulta
       ORDER BY Numero, Referencia

END

