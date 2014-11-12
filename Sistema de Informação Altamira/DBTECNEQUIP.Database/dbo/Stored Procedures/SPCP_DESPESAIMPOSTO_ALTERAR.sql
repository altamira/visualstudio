
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_ALTERAR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_ALTERAR    Script Date: 16/10/01 13:41:45 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_ALTERAR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_DESPESAIMPOSTO_ALTERAR

    @Sequencia    int,
    @TipoConta    char(1),
    @CodigoConta  smallint,
    @DataEmissao  smalldatetime,
    @ValorTotal   money,
    @Parcelas     SmallInt,
    @Periodo      varchar(30)

AS

BEGIN



    UPDATE CP_DespesaImposto
       SET cpdi_TipoConta   = @TipoConta,
           cpdi_CodigoConta = @CodigoConta,
           cpdi_DataEmissao = @DataEmissao,
           cpdi_ValorTotal  = @ValorTotal,
           cpdi_Parcelas    = @Parcelas,
           cpdi_Periodo     = @Periodo

     WHERE cpdi_Sequencia   = @Sequencia


END

