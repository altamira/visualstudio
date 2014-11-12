
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_INCLUIR    Script Date: 23/10/2010 15:32:31 ******/
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_INCLUIR    Script Date: 25/08/1999 20:11:23 ******/
CREATE PROCEDURE  SPCP_NOTAFISCALDET_INCLUIR

@Fornecedor         char(14),
@NotaFiscal         char(6),
@TipoNota           char(1),
@Pedido             int,
@Parcela            smallint,
@DataVencimento     smalldatetime,
@DataProrrogacao    smalldatetime,
@Valor              money,
@ValorMulta         money,
@ValorDesconto      money,
@ValorTotal         money,
@NumeroCheque       char(15),
@BancoCheque        char(3),
@CopiaCheque      char(15),
@DataPagamento      smalldatetime,
@BancoPagamento     char(3),
@DataPreDatado      smalldatetime,
@Grupo              tinyint,
@Destinacao         tinyint,
@Duplicata          char(7),
@Observacao         varchar(50),
@Valida          smallint,
@ObservaçãoProrrogação	text,
@ObservaçãoAbatimento	text

AS

BEGIN

	INSERT INTO CP_NotaFiscalDetalhe (cpnd_Fornecedor,
	                                  cpnd_NotaFiscal,
									  cpnd_TipoNota,
                                      cpnd_Pedido,
									  cpnd_Parcela,
									  cpnd_DataVencimento,
									  cpnd_DataProrrogacao,
									  cpnd_Valor,
									  cpnd_ValorMulta,
									  cpnd_ValorDesconto,
                                      cpnd_ValorTotal,
									  cpnd_NumeroCheque,
									  cpnd_BancoCheque,
									  cpnd_CopiaCheque,
									  cpnd_DataPagamento,
									  cpnd_BancoPagamento,
									  cpnd_DataPreDatado,
									  cpnd_Grupo,
									  cpnd_Destinacao,
                                      							cpnd_Duplicata,
									cpnd_Observacao,
                                      							cpnd_Valida,
									cpnd_ObservaçãoProrrogação,
									cpnd_ObservacãoAbatimento)

                              VALUES (@Fornecedor,
                                      @NotaFiscal,
                                      @TipoNota,
                                      @Pedido,
									  @Parcela,
									  @DataVencimento,
									  @DataProrrogacao,
									  @Valor,
									  @ValorMulta,
									  @ValorDesconto,
									  @ValorTotal,
									  @NumeroCheque,
									  @BancoCheque,
									  @CopiaCheque,
									  @DataPagamento,
									  @BancoPagamento,
									  @DataPreDatado,
									  @Grupo,
									  @Destinacao,
                                      @Duplicata,
									  @Observacao,
                                      @Valida,
									@ObservaçãoProrrogação,
									@ObservaçãoAbatimento
)

END










