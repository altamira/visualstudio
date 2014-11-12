
/****** Object:  Stored Procedure dbo.SPCP_CONSPREVDIADET_CONSULTA    Script Date: 23/10/2010 13:58:20 ******/
CREATE PROCEDURE [dbo].[SPCP_CONSPREVDIADET_CONSULTA]
 
    @Data       smalldateTime,
    @Tipo       char(1)
 
AS
 
BEGIN
 

    IF @Tipo = 'F' 
 
        BEGIN
 
            -- Cria tabela temporária para o detalhe
            CREATE TABLE #TabFornecedor (Fornecedor   char(40)   not null,
                                         NotaFiscal   char(6)    null,
                                         Parcela      char(7)    null,
                                         ValorTotal   money      null,
                                         Previsao     char(1)    null,
										 Valida smallint null)
            
            
            -- Insere os dados selecionados na tabela temporaria
            INSERT INTO #TabFornecedor (Fornecedor,
                                        NotaFiscal,
                                        Parcela,
                                        ValorTotal, 
   Valida)
            
            -- Seleciona os dados
            SELECT cofc_Nome,
                   cpnd_NotaFiscal,
                   LTRIM(RTRIM(CONVERT(char(3), cpnd_Parcela))) + '/' + LTRIM(RTRIM(CONVERT(char(3), cpnf_Parcelas))) cpnd_Parcela,
                   cpnd_ValorTotal,cpnd_Valida
              
              FROM CO_Fornecedor,
                   CP_NotaFiscal,
                   CP_NotaFiscalDetalhe
             
             WHERE cpnd_DataVencimento = @Data
               AND cpnd_DataProrrogacao Is Null
               AND cpnd_DataPagamento Is Null
               
               AND cofc_Codigo = cpnd_Fornecedor
 
               AND cpnf_Fornecedor = cpnd_Fornecedor
               AND cpnf_NotaFiscal = cpnd_NotaFiscal
               AND cpnf_TipoNota   = cpnd_TipoNota
               AND cpnf_Pedido     = cpnd_Pedido
 
            -- Insere os dados selecionados na tabela temporaria
            INSERT INTO #TabFornecedor (Fornecedor,
                                        NotaFiscal,
                                        Parcela,
                                        ValorTotal,
										Valida)
            
            -- Seleciona os dados
            SELECT cofc_Nome,
                   cpnd_NotaFiscal,
                   LTRIM(RTRIM(CONVERT(char(3), cpnd_Parcela))) + '/' + LTRIM(RTRIM(CONVERT(char(3), cpnf_Parcelas))) cpnd_Parcela,
                   cpnd_ValorTotal,cpnd_Valida
 
              FROM CO_Fornecedor,
                   CP_NotaFiscal,
                   CP_NotaFiscalDetalhe
             
             WHERE cpnd_DataProrrogacao = @Data
               AND cpnd_DataPagamento Is Null
               
 
               AND cofc_Codigo = cpnd_Fornecedor
 
               AND cpnf_Fornecedor = cpnd_Fornecedor
               AND cpnf_NotaFiscal = cpnd_NotaFiscal
               AND cpnf_TipoNota   = cpnd_TipoNota
               AND cpnf_Pedido     = cpnd_Pedido
            
            -- Insere os dados selecionados na tabela temporaria
            INSERT INTO #TabFornecedor (Fornecedor,
                                        Parcela,
                                        ValorTotal,
                                        Previsao,Valida)
 
            -- Seleciona os dados
            SELECT cofc_Nome,
                   cppr_Parcela,
                   cppr_Valor,'P',cppr_Valida
              
              FROM CO_Fornecedor,
                   CP_Previsao
             
             WHERE cppr_DataVencimento = @Data
               AND cppr_Tipo = @Tipo
               AND cofc_Codigo = cppr_Fornecedor
 

            -- Insere os dados selecionados na tabela temporaria
            INSERT INTO #TabFornecedor (Fornecedor,
                                        NotaFiscal,
                                        Parcela,
                                        ValorTotal,Valida)
            
            -- Seleciona os dados
            SELECT cofc_Nome,
                   'Sinal',
 
                   LTRIM(RTRIM(CONVERT(char(3), 1))) + '/' + LTRIM(RTRIM(CONVERT(char(3), 1))) cpnd_Parcela,
                   cpsp_Valor,cpsp_Valida
              
              FROM CO_Fornecedor,
                   CP_SinalPedido,
                   CO_Pedido
             
             WHERE cpsp_DataVencimento = @Data
               AND cpsp_DataPagamento Is Null
               
               AND cofc_Codigo = cope_Fornecedor
 
               AND cpsp_Pedido = cope_Numero
 
                        
            
          
            -- Retorna os dados para o VB
            SELECT * FROM #TabFornecedor ORDER BY Fornecedor
 
        END
    
    ELSE
 
        BEGIN
 
            IF @Tipo = 'D' 
 
                BEGIN
     
                    -- Cria tabela temporária para o detalhe
                    CREATE TABLE #TabDespesa (Descricao   char(40)   not null,
                                              Parcela      char(7)    null,
                                              ValorTotal   money      null,
                                              Previsao     char(1)    null,
                                              Observacao   varchar(250) null,
   Sequencia integer null,
   Valida  smallint)
            
                    -- Insere os dados selecionados na tabela temporaria
                    INSERT INTO #TabDespesa (Descricao,
                                             Parcela,
                                             ValorTotal,
                                             Observacao,
   Sequencia,
   Valida)
 
                    -- Seleciona os dados
                    SELECT cpde_Descricao,
                           LTRIM(RTRIM(CONVERT(char(3), cpdd_Parcela))) + '/' + LTRIM(RTRIM(CONVERT(char(3), cpdi_Parcelas))) cpdd_Parcela,
                           cpdd_ValorTotal, 
                           cpdd_Observacao, cpdd_Sequencia,cpdd_Valida
              
                      FROM CP_Descricao,
                           CP_DespesaImposto,
                           CP_DespesaImpostoDetalhe
            
                     WHERE cpdd_DataVencimento = @Data
                       AND cpdd_Dataprorrogacao Is Null
                       AND cpdd_DataPagamento Is Null
 
                       AND cpdi_Sequencia = cpdd_Sequencia
                       AND cpdi_TipoConta = @Tipo
 
                       AND cpde_Codigo = cpdi_CodigoConta
                       AND cpde_Tipo   = cpdi_TipoConta
 

                    -- Insere os dados selecionados na tabela temporaria
                    INSERT INTO #TabDespesa (Descricao,
                                             Parcela,
                                             ValorTotal,
                                             Observacao, Sequencia,Valida)
 
                    -- Seleciona os dados
                    SELECT cpde_Descricao,
                           LTRIM(RTRIM(CONVERT(char(3), cpdd_Parcela))) + '/' + LTRIM(RTRIM(CONVERT(char(3), cpdi_Parcelas))) cpdd_Parcela,
                           cpdd_ValorTotal,
                           cpdd_Observacao, cpdd_Sequencia,cpdd_Valida
              
                      FROM CP_Descricao,
                           CP_DespesaImposto,
                           CP_DespesaImpostoDetalhe
            
                     WHERE cpdd_Dataprorrogacao = @Data
                       AND cpdd_DataPagamento Is Null
 
                       AND cpdi_Sequencia = cpdd_Sequencia
                       AND cpdi_TipoConta = @Tipo
 
                       AND cpde_Codigo = cpdi_CodigoConta
                       AND cpde_Tipo   = cpdi_TipoConta
 
                        -- Insere os dados selecionados na tabela temporaria
                        INSERT INTO #TabDespesa  (Descricao,
                                                  Parcela,
                                                  ValorTotal,
                                                  Previsao,
                                                  Observacao , Sequencia,Valida)
 
                        -- Seleciona os dados
               SELECT cpde_Descricao,
                               cppr_Parcela,
                               cppr_Valor,
                               'P',
                               cppr_Observacao , cppr_Sequencia,cppr_Valida
              
                          FROM CP_Descricao,
                               CP_Previsao
             
                         WHERE cppr_DataVencimento = @Data
                           AND cppr_Tipo = @Tipo
                           
                           AND cpde_Codigo = cppr_Descricao
                           AND cpde_Tipo   = cppr_Tipo
 
                        SELECT * FROM #TabDespesa ORDER BY Descricao
 
                END
 
            ELSE
 
                BEGIN
 
                    IF @Tipo = 'I'
 
                        BEGIN
 
                            -- Cria tabela temporária para o detalhe
                            CREATE TABLE #TabImposto (Descricao    char(40)   not null,
                                                      Parcela      char(7)    null,
                                                      Periodo      char(50)   null,
                                                      ValorTotal   money      null,
                                                      Previsao     char(1)    null,
                 Observacao char(250)  null,
    Sequencia  integer null,
    Valida smallint)
            
                            -- Insere os dados selecionados na tabela temporaria
                            INSERT INTO #TabImposto (Descricao,
                                                     Parcela,
                                                     Periodo,
                                                     ValorTotal,
    Observacao, Sequencia,Valida)
 
                            -- Seleciona os dados
                            SELECT cpde_Descricao,
                                   LTRIM(RTRIM(CONVERT(char(3), cpdd_Parcela))) + '/' + LTRIM(RTRIM(CONVERT(char(3), cpdi_Parcelas))) cpdd_Parcela,
                                   cpdi_Periodo,
                                   cpdd_ValorTotal,
          cpdd_Observacao, cpdd_Sequencia,cpdd_Valida
              
                              FROM CP_Descricao,
                                   CP_DespesaImposto,
                                   CP_DespesaImpostoDetalhe
            
                             WHERE cpdd_DataVencimento = @Data
                               AND cpdd_Dataprorrogacao Is Null
                               AND cpdd_DataPagamento Is Null
 
                               AND cpdi_Sequencia = cpdd_Sequencia
                               AND cpdi_TipoConta = @Tipo
 
                               AND cpde_Codigo = cpdi_CodigoConta
                               AND cpde_Tipo   = cpdi_TipoConta
 

                            -- Insere os dados selecionados na tabela temporaria
                            INSERT INTO #TabImposto (Descricao,
                                                     Parcela,
                                                     Periodo,
                                                     ValorTotal,
    Observacao,sequencia,Valida)
 
                            -- Seleciona os dados
                            SELECT cpde_Descricao,
                                   LTRIM(RTRIM(CONVERT(char(3), cpdd_Parcela))) + '/' + LTRIM(RTRIM(CONVERT(char(3), cpdi_Parcelas))) cpdd_Parcela,
                                   cpdi_Periodo,
                                   cpdd_ValorTotal,
          cpdd_Observacao,cpdd_Sequencia,cpdd_Valida
              
                              FROM CP_Descricao,
                                   CP_DespesaImposto,
                                   CP_DespesaImpostoDetalhe
            
                             WHERE cpdd_Dataprorrogacao = @Data
                               AND cpdd_DataPagamento Is Null
 
                               AND cpdi_TipoConta = @Tipo
                               AND cpdi_Sequencia = cpdd_Sequencia
 
                               AND cpde_Codigo = cpdi_CodigoConta
                               AND cpde_Tipo   = cpdi_TipoConta
 
                            -- Insere os dados selecionados na tabela temporaria
                            INSERT INTO #TabImposto  (Descricao,
                                Parcela,
                                                      Observacao,
                                                      ValorTotal,
                                                      Previsao,sequencia,Valida)
 
                            -- Seleciona os dados
                            SELECT cpde_Descricao,
                                   cppr_Parcela,
                                   cppr_Observacao,
                                   cppr_Valor,
                                   'P',cppr_sequencia,cppr_Valida
              
                              FROM CP_Descricao,
                                   CP_Previsao
             
                             WHERE cppr_DataVencimento = @Data
                               AND cppr_Tipo = @Tipo
                           
                               AND cpde_Codigo = cppr_Descricao
                               AND cpde_Tipo   = cppr_Tipo
 
                            SELECT * FROM #TabImposto ORDER BY Descricao
 

                        END
                    
                   END
 
        END
END
 


