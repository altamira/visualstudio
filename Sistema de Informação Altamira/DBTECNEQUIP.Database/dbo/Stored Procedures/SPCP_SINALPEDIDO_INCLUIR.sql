
/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_INCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_INCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_INCLUIR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_SINALPEDIDO_INCLUIR

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

    INSERT INTO CP_SinalPedido(cpsp_Sequencia,
                               cpsp_Pedido,
                               cpsp_DataVencimento,
                               cpsp_Valor,
                               cpsp_NumeroCheque,
                               cpsp_BancoCheque,
                               cpsp_CopiaCheque,
                               cpsp_DataPagamento,
                               cpsp_BancoPagamento,
                               cpsp_DataPreDatado,
                               cpsp_Observacao,
                               cpsp_Exclusao)

                    Values (@Sequencia,
                            @Pedido,
                            @DataVencimento,
                            @Valor,
                            @NumeroCheque,
                            @BancoCheque,
                            @CopiaCheque,
                            @DataPagamento,
                            @BancoPagamento,
                            @DataPreDatado,
                            @Observacao,
                            0)

END

