
/****** Object:  Stored Procedure dbo.SPCP_SINALSELECIONA_EXECUTA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCP_SINALSELECIONA_EXECUTA    Script Date: 16/10/01 13:41:52 ******/
/****** Object:  Stored Procedure dbo.SPCP_SINALSELECIONA_EXECUTA    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_SINALSELECIONA_EXECUTA

    @Fornecedor     char(14),
    @NotaFiscal     char(6),
    @TipoNota       char(1),
    @Pedido         int,
    @Parcela        smallint,
    @SequenciaSinal int


AS

DECLARE @NumeroOP         int,
        @DataOP           smalldatetime,
        @NumeroOPAntigo   int,
        @DataOPAntigo     smalldatetime,
        @ValorParcela     money,
        @ValorSinal       money,
        @ValorAntigo      money,
        @ValorAtual       money

BEGIN

    -- Pega o numero da OP e data da OP
    SELECT @NumeroOP   = cpsp_NumeroOP,
           @DataOP     = cpsp_DataOP,
           @ValorSinal = cpsp_Valor
      FROM CP_SinalPedido
     WHERE cpsp_Sequencia = @SequenciaSinal

    -- Verifica se ja existe uma OP
    SELECT @NumeroOPAntigo = cpnd_NumeroOP,
           @DataOPAntigo   = cpnd_DataOP,
           @ValorParcela   = cpnd_ValorTotal
      FROM CP_NotaFiscalDetalhe
     WHERE cpnd_Fornecedor = @Fornecedor
       AND cpnd_NotaFiscal = @NotaFiscal
       AND cpnd_TipoNota   = @TipoNota
       AND cpnd_Pedido     = @Pedido
       AND cpnd_Parcela    = @Parcela


    -- Verifica se tem este numero de OP no sinal
    IF NOT EXISTS (SELECT 'X' FROM CP_SinalPedido WHERE cpsp_NumeroOP = @NumeroOPAntigo)

        BEGIN

           -- Verifica se o valor da parcela é o valor total 
           -- do sinal

            IF @ValorParcela - @ValorSinal >= 0 

                BEGIN

                    UPDATE CP_SinalPedido
                       SET cpsp_Exclusao = 1
                     WHERE cpsp_Sequencia = @SequenciaSinal

                END

            ELSE
            
                BEGIN
               
                    UPDATE CP_SinalPedido
                       SET cpsp_Valor = @ValorSinal - @ValorParcela 
                     WHERE cpsp_Sequencia = @SequenciaSinal

                END 

        END

    ELSE
    
        BEGIN
        
            SELECT @ValorAntigo = cpsp_Valor
              FROM CP_SinalPedido 
             WHERE cpsp_NumeroOP = @NumeroOPAntigo

            
            SELECT @ValorAtual = @ValorParcela - @ValorAntigo

            IF @ValorAtual - @ValorSinal >= 0 

                BEGIN

                    UPDATE CP_SinalPedido
                       SET cpsp_Exclusao = 1
                     WHERE cpsp_Sequencia = @SequenciaSinal

                END

            ELSE
            
                BEGIN
               
                    UPDATE CP_SinalPedido
                       SET cpsp_Valor = @ValorSinal - @ValorAtual
                     WHERE cpsp_Sequencia = @SequenciaSinal

                END 

        
        END   

    -- Atualiza o numero e data da op
    UPDATE CP_NotaFiscalDetalhe
       SET cpnd_NumeroOP = @NumeroOP,
           cpnd_DataOP   = @DataOP
     WHERE cpnd_Fornecedor = @Fornecedor
       AND cpnd_NotaFiscal = @NotaFiscal
       AND cpnd_TipoNota   = @TipoNota
       AND cpnd_Parcela    = @Parcela
       AND cpnd_Pedido     = @Pedido


END

