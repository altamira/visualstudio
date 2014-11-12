
/****** Object:  Stored Procedure dbo.SPCP_OPREIMPRESSAO_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_OPREIMPRESSAO_SELECIONA    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_OPREIMPRESSAO_SELECIONA

    @TipoOP      char(1),
    @DataInicial smalldatetime,
    @DataFinal   smalldatetime

AS

BEGIN


    -- Verifica se é Fornecedor 
    IF @TipoOP = 'F'

        BEGIN

            SELECT cpnd_NumeroOP cpdd_NumeroOP,
                   cpnd_DataOP cpdd_DataOP

              FROM CP_NotaFiscalDetalhe

             WHERE cpnd_NumeroOP is Not Null
               AND cpnd_DataOP Between @DataInicial AND @DataFinal

        END

      ELSE 

        BEGIN

            IF @TipoOP = 'D' or @TipoOP = 'I'

                BEGIN

                    SELECT cpdd_NumeroOP,
                           cpdd_DataOP,
                           cpdd_Sequencia,
                           cpdd_Parcela

                      FROM CP_DespesaImpostoDetalhe,
                           CP_DespesaImposto

                     WHERE cpdi_TipoConta = @TipoOP
               
                       AND cpdd_Sequencia = cpdi_Sequencia

                       AND cpdd_NumeroOP is Not Null
                       AND cpdd_DataOP Between @DataInicial AND @DataFinal

                END 
        
            ELSE

                BEGIN

                    SELECT cpsp_NumeroOP cpdd_NumeroOP,
                           cpsp_DataOP cpdd_DataOP,
                           cpsp_Sequencia

                      FROM CP_SinalPedido

                     WHERE cpsp_NumeroOP is Not Null
                       AND cpsp_DataOP Between @DataInicial AND @DataFinal

                END


         END
END




