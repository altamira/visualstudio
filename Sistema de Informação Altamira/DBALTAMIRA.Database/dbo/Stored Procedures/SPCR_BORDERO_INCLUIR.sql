
/****** Object:  Stored Procedure dbo.SPCR_BORDERO_INCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCR_BORDERO_INCLUIR    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCR_BORDERO_INCLUIR

@NotaFiscal       int,
@TipoNota         char(1),
@Parcela          tinyint,
@Banco            char(3),
@Cliente          char(14),
@DataVencimento   smalldatetime,
@Valor            money,
@IOF              money,
@Juros            money,
@Custos           money,
@Dias            numeric

AS

BEGIN

	INSERT INTO CR_Bordero (crbo_NotaFiscal,
                            crbo_TipoNota,
                            crbo_Parcela,
                            crbo_Banco,
                            crbo_Cliente,
                            crbo_DataVencimento,
                            crbo_ValorDuplicata,
                            crbo_ValorIOF,
                            crbo_ValorJuros,
                            crbo_ValorCustos,
                            crbo_Dias)

		      VALUES (@NotaFiscal,
                      @TipoNota,
                      @Parcela,
                      @Banco,
                      @Cliente,
                      @DataVencimento,
                      @Valor,
                      @IOF,
                      @Juros,
                      @Custos,
                      @Dias)

END


