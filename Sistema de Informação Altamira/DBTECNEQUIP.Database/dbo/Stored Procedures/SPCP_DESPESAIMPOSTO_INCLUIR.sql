
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_INCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_INCLUIR    Script Date: 16/10/01 13:41:45 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_DESPESAIMPOSTO_INCLUIR

    @Sequencia    int,
    @TipoConta    char(1),
    @CodigoConta  smallint,
    @DataEmissao  smalldatetime,
    @ValorTotal   money,
    @Parcelas     SmallInt,
    @Periodo      varchar(30)

AS

BEGIN


    INSERT INTO  CP_DespesaImposto (cpdi_Sequencia,
                                    cpdi_TipoConta,
                                    cpdi_CodigoConta,
                                    cpdi_DataEmissao,
                                    cpdi_ValorTotal,
                                    cpdi_Parcelas,
                                    cpdi_Periodo)

                    VALUES (@Sequencia,
                            @TipoConta,
                            @CodigoConta,
                            @DataEmissao,
                            @ValorTotal,
                            @Parcelas,
                            @Periodo)

END

