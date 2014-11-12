
/****** Object:  Stored Procedure dbo.SPCP_CONSCOPIACHEQUE_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_CONSCOPIACHEQUE_CONSULTA    Script Date: 25/08/1999 20:11:53 ******/
CREATE PROCEDURE SPCP_CONSCOPIACHEQUE_CONSULTA

    @DataInicial    smalldatetime,
    @DataFinal      smalldatetime

AS

DECLARE @NumeroCopiaCheque int,
        @Tipo char(1),
        @Chave  char(25),
        @ProximoNumeroCheque int,
        @ChaveAnterior     char(25),
        @TipoAnterior    char(1),
        @PrimeiraVez int,
        @Diferenca Int,
        @Parcela  smallint,
        @ParcelaAnterior  smallint

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

    -- Cria tabela para verificacao da copia de cheque
    CREATE TABLE #TabCopiaCheque (Numero int null,
                                  Tipo char(1) null,
                                  Chave char(25) null,
                                  Parcela smallint null)



    -- Insere valores na tabela
    INSERT INTO #TabCopiaCheque (Numero, Tipo, chave, Parcela)

    SELECT cpdd_CopiaCheque, cpdi_TipoConta, CONVERT(char(25), cpdd_Sequencia), cpdd_Parcela
      FROM CP_DespesaImpostoDetalhe,
           CP_DespesaImposto
     WHERE cpdd_DataPagamento BETWEEN @DataInicial AND @DataFinal
       AND cpdd_Sequencia = cpdi_Sequencia     

    INSERT INTO #TabCopiaCheque (Numero, Tipo, Chave, Parcela)

    SELECT cpnd_CopiaCheque, 'F', cpnd_Fornecedor + cpnd_NotaFiscal + cpnd_TipoNota, cpnd_Parcela
      FROM CP_NotaFiscalDetalhe
     WHERE cpnd_DataPagamento BETWEEN @DataInicial AND @DataFinal

    INSERT INTO #TabCopiaCheque (Numero, Tipo, chave, Parcela)

    SELECT cpsp_CopiaCheque, 'S', CONVERT(char(25), cpsp_Sequencia), 1
      FROM CP_SinalPedido
     WHERE cpsp_DataPagamento BETWEEN @DataInicial AND @DataFinal


    -- Declara Cursor para verificação da orderm
    DECLARE curCheque INSENSITIVE CURSOR
        FOR SELECT Numero, Tipo, Chave, Parcela
              FROM #TabCopiaCheque
          ORDER BY Numero
    

    OPEN curCheque

    FETCH NEXT FROM curCheque INTO
                    @NumeroCopiaCheque,
                    @Tipo,
                    @Chave,
                    @Parcela

    SELECT @ProximoNumeroCheque = @NumeroCopiaCheque,
           @TipoAnterior        = @Tipo,
           @ChaveAnterior       = @Chave,
           @ParcelaAnterior     = @Parcela

    SELECT @PrimeiraVez = 1

    WHILE @@FETCH_STATUS = 0

        BEGIN
        
            IF @PrimeiraVez = 0 

                BEGIN

                    IF @NumeroCopiaCheque - 1 = @ProximoNumeroCheque OR @NumeroCopiaCheque = @ProximoNumeroCheque
            
                        BEGIN 
                        
                            IF @TipoAnterior = 'D' or @TipoAnterior = 'I' 
                            
                                BEGIN
                              
                              
                                    INSERT INTO #TabConsulta (Numero,
                                                              DataPagamento,
                                                              Referencia,
                                                              Periodo,
                                                              NumeroCheque,
                                                              Banco,
                                                              Valor)


                                    SELECT @ProximoNumeroCheque,
                                           cpdd_DataPagamento,
                                           cpde_Descricao,
                                           cpdi_Periodo,
                                           cpdd_NumeroCheque,
                                           cpdd_BancoCheque,
                                           cpdd_Valortotal

                                      FROM CP_DespesaImpostoDetalhe,
                                           CP_DespesaImposto,
                                           CP_Descricao
                                     WHERE cpdi_Sequencia = CONVERT(int, SUBSTRING(@ChaveAnterior, 1, 25))
                                       AND cpdd_Parcela   = @ParcelaAnterior
                                       AND cpdd_Sequencia =  cpdi_Sequencia
                                       AND cpde_Codigo = cpdi_CodigoConta
                                       AND cpde_Tipo   = cpdi_TipoConta
                                    
                                
                                END

                             ELSE

                                BEGIN
 
                                    IF @TipoAnterior = 'S'

                                        BEGIN

                                            INSERT INTO #TabConsulta (Numero,
                                                                      DataPagamento,
                                                                      Referencia,
                                                                      NotaFiscal,
                                                                      Periodo,
                                                                      NumeroCheque,
                                                                      Banco,
                                                                      Valor)



                                            SELECT @ProximoNumeroCheque,
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

                                             WHERE cpsp_Sequencia = CONVERT(int, SUBSTRING(@ChaveAnterior, 1, 25))
                                               AND cope_Numero = cpsp_Pedido
                                               AND cofc_Codigo = cope_Fornecedor

                                        END
                                    
                                      ELSE

                                        BEGIN

                                            INSERT INTO #TabConsulta (Numero,
                                                                      DataPagamento,
                                                                      Referencia,
                                                                      NotaFiscal,
                                                                      Periodo,
                                                                      NumeroCheque,
                                                                      Banco,
                                                                      Valor)



                                            SELECT @ProximoNumeroCheque,
                                                   cpnd_DataPagamento,
                                                   cofc_Nome,
                                                   cpnd_NotaFiscal,
                                                   cpnd_Duplicata,
                                                   cpnd_NumeroCheque,
                                                   cpnd_BancoCheque,
                                                   cpnd_ValorTotal
                                      
                                              FROM CP_NotaFiscalDetalhe,
                                                   CO_Fornecedor

                                             WHERE cpnd_Fornecedor = SUBSTRING(@ChaveAnterior, 1, 14)
                                               AND cpnd_NotaFiscal = SUBSTRING(@ChaveAnterior, 15, 6)
                                               AND cpnd_TipoNota   = SUBSTRING(@ChaveAnterior, 21, 1)
                                               AND cpnd_Parcela = @ParcelaAnterior
    
                                               AND cofc_Codigo = cpnd_Fornecedor

                             
                                        END
                             
                                END
                                
                        END

                    ELSE   --Caso seja cancelado

                        BEGIN

                            IF @TipoAnterior = 'D' or @TipoAnterior = 'I' 
                            
                                BEGIN

                                    INSERT INTO #TabConsulta (Numero,
                                                              DataPagamento,
                                                              Referencia,
                                                              Periodo,
                                                              NumeroCheque,
                                                              Banco,
                                                              Valor)


                                    SELECT @ProximoNumeroCheque,
                                           cpdd_DataPagamento,
                                           cpde_Descricao,
                                           cpdi_Periodo,
                                           cpdd_NumeroCheque,
                                           cpdd_BancoCheque,
                                           cpdd_Valortotal

                                      FROM CP_DespesaImpostoDetalhe,
                                           CP_DespesaImposto,
                                           CP_Descricao

                                     WHERE cpdi_Sequencia = CONVERT(int, SUBSTRING(@ChaveAnterior, 1, 25))
                                       AND cpdd_Parcela   = @ParcelaAnterior
                                       AND cpdd_Sequencia =  cpdi_Sequencia
                                       AND cpde_Codigo = cpdi_CodigoConta
                                       AND cpde_Tipo   = cpdi_TipoConta

                                
                                END

                             ELSE

                                BEGIN
                        
                                    IF @TipoAnterior = 'S'

                                        BEGIN

                                            INSERT INTO #TabConsulta (Numero,
                                                                      DataPagamento,
                                                                      Referencia,
                                                                      NotaFiscal,
                                                                      Periodo,
                                                                      NumeroCheque,
                                                                      Banco,
                                                                      Valor)



                                            SELECT @ProximoNumeroCheque,
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

                                             WHERE cpsp_Sequencia = CONVERT(int, SUBSTRING(@ChaveAnterior, 1, 25))
                                               AND cope_Numero = cpsp_Pedido
                                               AND cofc_Codigo = cope_Fornecedor

                                        END

                                       ELSE

                                        BEGIN

                                            INSERT INTO #TabConsulta (Numero,
                                                                      DataPagamento,
                                                                      Referencia,
                                                                      NotaFiscal,
                                                                      Periodo,
                                                                      NumeroCheque,
                                                                      Banco,
                                                                      Valor)



                                            SELECT @ProximoNumeroCheque,
                                                   cpnd_DataPagamento,
                                                   cofc_Nome,
                                                   cpnd_NotaFiscal,
                                                   cpnd_Duplicata,
                                                   cpnd_NumeroCheque,
                                                   cpnd_BancoCheque,
                                                   cpnd_ValorTotal
                                      
                                              FROM CP_NotaFiscalDetalhe,
                                                   CO_Fornecedor

                                             WHERE cpnd_Fornecedor = SUBSTRING(@ChaveAnterior, 1, 14)
                                               AND cpnd_NotaFiscal = SUBSTRING(@ChaveAnterior, 15, 6)
                                               AND cpnd_TipoNota   = SUBSTRING(@ChaveAnterior, 21, 1)
                                               AND cpnd_Parcela = @ParcelaAnterior
    
                                               AND cofc_Codigo = cpnd_Fornecedor

                             
                                        END
                                END
                         
                            SELECT @Diferenca = @NumeroCopiaCheque - (@ProximoNumeroCheque + 1)

                            WHILE @Diferenca > 0

                                BEGIN
                                        
                                    INSERT INTO #TabConsulta(Numero) Values(@NumeroCopiaCheque - @Diferenca)

                                    SELECT @Diferenca = @Diferenca - 1

                                END



                        END
                    
                END

            SELECT @ProximoNumeroCheque = @NumeroCopiaCheque,
                   @TipoAnterior        = @Tipo,
                   @ChaveAnterior       = @Chave,
                   @ParcelaAnterior     = @Parcela

            SELECT @PrimeiraVez = 0

            FETCH NEXT FROM curCheque INTO
                            @NumeroCopiaCheque,
                            @Tipo,
                            @Chave,
                            @Parcela

        END

     CLOSE curCheque
DEALLOCATE curCheque

-- Insere a ultima linha

    IF @TipoAnterior = 'D' or @TipoAnterior = 'I' 

        BEGIN

            INSERT INTO #TabConsulta (Numero,
                                      DataPagamento,
                                      Referencia,
                                      Periodo,
                                      NumeroCheque,
                                      Banco,
                                      Valor)


            SELECT @ProximoNumeroCheque,
                   cpdd_DataPagamento,
                   cpde_Descricao,
                   cpdi_Periodo,
                   cpdd_NumeroCheque,
                   cpdd_BancoCheque,
                   cpdd_Valortotal

              FROM CP_DespesaImpostoDetalhe,
                   CP_DespesaImposto,
                   CP_Descricao

             WHERE cpdi_Sequencia = CONVERT(int, SUBSTRING(@ChaveAnterior, 1, 25))
               AND cpdd_Parcela   = @ParcelaAnterior
               AND cpdd_Sequencia =  cpdi_Sequencia
               AND cpde_Codigo = cpdi_CodigoConta
               AND cpde_Tipo   = cpdi_TipoConta

    
        END

     ELSE

        BEGIN

        IF @TipoAnterior = 'S'

            BEGIN

                INSERT INTO #TabConsulta (Numero,
                                          DataPagamento,
                                          Referencia,
                                          NotaFiscal,
                                          Periodo,
                                          NumeroCheque,
                                          Banco,
                                          Valor)



                SELECT @ProximoNumeroCheque,
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

                 WHERE cpsp_Sequencia = CONVERT(int, SUBSTRING(@ChaveAnterior, 1, 25))
                   AND cope_Numero = cpsp_Pedido
                   AND cofc_Codigo = cope_Fornecedor

            END

           ELSE

            BEGIN

                INSERT INTO #TabConsulta (Numero,
                                          DataPagamento,
                                          Referencia,
                                          NotaFiscal,
                                          Periodo,
                                          NumeroCheque,
                                          Banco,
                                          Valor)



                SELECT @ProximoNumeroCheque,
                       cpnd_DataPagamento,
                       cofc_Nome,
                       cpnd_NotaFiscal,
                       cpnd_Duplicata,
                       cpnd_NumeroCheque,
                       cpnd_BancoCheque,
                       cpnd_ValorTotal
          
                  FROM CP_NotaFiscalDetalhe,
                       CO_Fornecedor

                 WHERE cpnd_Fornecedor = SUBSTRING(@ChaveAnterior, 1, 14)
                   AND cpnd_NotaFiscal = SUBSTRING(@ChaveAnterior, 15, 6)
                   AND cpnd_TipoNota   = SUBSTRING(@ChaveAnterior, 21, 1)
                   AND cpnd_Parcela = @ParcelaAnterior

                   AND cofc_Codigo = cpnd_Fornecedor

 
            END

        END

    SELECT * FROM #TabConsulta

END

