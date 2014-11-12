
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_ALTERAR    Script Date: 25/08/1999 20:11:23 ******/
CREATE PROCEDURE  SPCP_DESPESAIMPOSTODET_ALTERAR

@Sequencia          int,
@Parcela            smallint,
@DataVencimento     smalldatetime,
@DataProrrogacao    smalldatetime,
@Valor              money,
@ValorMulta         money,
@ValorDesconto      money,
@ValorTotal         money,
@NumeroCheque       char(15),
@BancoCheque        char(3),
@CopiaCheque            char(15),
@DataPagamento      smalldatetime,
@BancoPagamento     char(3),
@DataPreDatado      smalldatetime,
@Grupo              tinyint,
@Destinacao         tinyint,
@Observacao         varchar(250)

AS

BEGIN

	UPDATE CP_DespesaImpostoDetalhe
	      SET cpdd_DataVencimento = @DataVencimento,
			  cpdd_DataProrrogacao = @DataProrrogacao ,
			  cpdd_Valor = @Valor,
			  cpdd_ValorAcrescimo = @ValorMulta,
			  cpdd_ValorDesconto = @ValorDesconto,
              cpdd_ValorTotal = @ValorTotal,
			  cpdd_NumeroCheque = @NumeroCheque,
			  cpdd_BancoCheque = @BancoCheque,
			  cpdd_CopiaCheque = @CopiaCheque,
			  cpdd_DataPagamento = @DataPagamento,
			  cpdd_BancoPagamento = @BancoPagamento,
			  cpdd_DataPreDatado = @DataPreDatado,
			  cpdd_Grupo = @Grupo,
			  cpdd_Destinacao = @Destinacao,
			  cpdd_Observacao = @Observacao
          
		 WHERE cpdd_Sequencia = @Sequencia
           AND cpdd_Parcela = @Parcela
			                
END










