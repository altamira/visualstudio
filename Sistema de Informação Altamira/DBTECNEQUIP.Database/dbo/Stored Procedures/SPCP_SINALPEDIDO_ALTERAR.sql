
/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_ALTERAR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_ALTERAR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_ALTERAR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_SINALPEDIDO_ALTERAR

    @Sequencia                 int,
    @Pedido                    int,
    @DataVencimento            smalldatetime,
    @Valor                     money,
    @NumeroCheque              char(15),
    @BancoCheque               char(3),
    @CopiaCheque               int,
    @DataPagamento             smalldatetime,
    @BancoPagamento            char(3),
    @DataPreDatado             smalldatetime,
    @Observacao                varchar(50)


AS


BEGIN


    UPDATE CP_SinalPedido 
       SET cpsp_Pedido = @Pedido,
           cpsp_DataVencimento = @DataVencimento,
           cpsp_Valor = @Valor,
           cpsp_NumeroCheque = @NumeroCheque,
           cpsp_BancoCheque = @BancoCheque,
           cpsp_CopiaCheque = @CopiaCheque,
           cpsp_DataPagamento = @DataPagamento,
           cpsp_BancoPagamento = @BancoPagamento,
           cpsp_DataPreDatado =  @DataPreDatado,
           cpsp_Observacao = @Observacao
     WHERE cpsp_Sequencia = @Sequencia



END

