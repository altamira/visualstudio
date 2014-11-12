
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_ALTERAR    Script Date: 23/10/2010 15:32:31 ******/
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_ALTERAR    Script Date: 25/08/1999 20:11:23 ******/
CREATE PROCEDURE  SPCP_NOTAFISCALDET_ALTERAR

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
@CopiaCheque          char(15),
@DataPagamento      smalldatetime,
@BancoPagamento     char(3),
@DataPreDatado      smalldatetime,
@Grupo              tinyint,
@Destinacao         tinyint,
@Duplicata          char(7),
@Observacao         varchar(50),
@ObservaçãoProrrogação	text,
@ObservaçãoAbatimento	text,
@Valida          smallint

AS

BEGIN

	UPDATE CP_NotaFiscalDetalhe
	      SET cpnd_DataVencimento = @DataVencimento,
			  cpnd_DataProrrogacao = @DataProrrogacao ,
			  cpnd_Valor = @Valor,
			  cpnd_ValorMulta = @ValorMulta,
			  cpnd_ValorDesconto = @ValorDesconto,
              		  cpnd_ValorTotal = @ValorTotal,
			  cpnd_NumeroCheque = @NumeroCheque,
			  cpnd_BancoCheque = @BancoCheque,
			  cpnd_CopiaCheque = @CopiaCheque,
			  cpnd_DataPagamento = @DataPagamento,
			  cpnd_BancoPagamento = @BancoPagamento,
			  cpnd_DataPreDatado = @DataPreDatado,
			  cpnd_Grupo = @Grupo,
			  cpnd_Destinacao = @Destinacao,
		               cpnd_Duplicata = @Duplicata,
			  cpnd_Observacao = @Observacao,
			  cpnd_ObservaçãoProrrogação		= @ObservaçãoProrrogação,
			  cpnd_ObservacãoAbatimento 		= @ObservaçãoAbatimento  ,
			  cpnd_Valida = @Valida
		  WHERE  cpnd_Fornecedor = @Fornecedor
		         AND cpnd_NotaFiscal = @NotaFiscal
		         AND cpnd_TipoNota = @TipoNota
		         AND cpnd_Parcela = @Parcela
 		         AND cpnd_Pedido = @Pedido
			                
END






