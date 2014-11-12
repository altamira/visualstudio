
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_INCLUIR    Script Date: 25/08/1999 20:11:39 ******/
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

