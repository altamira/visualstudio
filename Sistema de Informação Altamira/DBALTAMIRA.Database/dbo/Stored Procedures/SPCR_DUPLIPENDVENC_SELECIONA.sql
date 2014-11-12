
/****** Object:  Stored Procedure dbo.SPCR_DUPLIPENDVENC_SELECIONA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_DUPLIPENDVENC_SELECIONA    Script Date: 25/08/1999 20:11:41 ******/
CREATE PROCEDURE SPCR_DUPLIPENDVENC_SELECIONA

@Data       smalldatetime

AS

BEGIN

      -- Cria tabela temporária para o detalhe
      CREATE TABLE #TabCliente (Cliente      char(60)   not null,
                                NotaFiscal   int        not null,
                                TipoNota     char(1)    not null,
                                Parcela      smallint   not null,
                                ValorTotal   money      not null,
                                Banco        char(15)   null)
            
            
            -- Insere os dados selecionados na tabela temporaria
            INSERT INTO #TabCliente (Cliente,
                                     NotaFiscal,
                                     TipoNota,
                                     Parcela,
                                     ValorTotal,
                                     Banco)
            
            -- Seleciona os dados
            SELECT vecl_Nome,
           		crnd_NotaFiscal,
           		crnd_TipoNota,
                   	crnd_Parcela,
                   	crnd_ValorTotal,
                   	fnba_NomeBanco
              FROM CR_NotasFiscaisDetalhe,
                   FN_Bancos,
                   VE_Clientes
             
             WHERE crnd_DataVencimento = @Data
               AND crnd_DataProrrogacao Is Null
               AND crnd_DataPagamento Is Null
               AND crnd_Banco      = fnba_Codigo
               AND crnd_CNPJ       = vecl_Codigo



            -- Insere os dados selecionados na tabela temporaria
            INSERT INTO #TabCliente (Cliente,
                                     NotaFiscal,
                                     TipoNota,
                                     Parcela,
                                     ValorTotal,
                                     Banco)
            
            -- Seleciona os dados
            SELECT vecl_Nome,
           		crnd_NotaFiscal,
           		crnd_TipoNota,
                   	crnd_Parcela,
                   	crnd_ValorTotal,
                   	fnba_NomeBanco
              FROM CR_NotasFiscaisDetalhe,
                   FN_Bancos,
                   VE_Clientes
                
             WHERE crnd_DataProrrogacao = @Data
               AND crnd_DataPagamento Is Null
               AND crnd_Banco      = fnba_Codigo
               AND crnd_CNPJ       = vecl_Codigo
         
   SELECT * FROM #TabCliente order by Banco,Cliente

END

           
             





