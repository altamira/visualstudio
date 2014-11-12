
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_INCLUIR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_INCLUIR    Script Date: 16/10/01 13:41:48 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE  SPCP_DESPESAIMPOSTODET_INCLUIR

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
@CopiaCheque        int,
@DataPagamento      smalldatetime,
@BancoPagamento     char(3),
@DataPreDatado      smalldatetime,
@Grupo              tinyint,
@Destinacao         tinyint,
@Observacao         varchar(50)

AS

BEGIN

	INSERT INTO CP_DespesaImpostoDetalhe (cpdd_sequencia,
              cpdd_Parcela,
              cpdd_DataVencimento, 
			  cpdd_DataProrrogacao,
			  cpdd_Valor,
			  cpdd_ValorAcrescimo,
			  cpdd_ValorDesconto,
              cpdd_ValorTotal,
			  cpdd_NumeroCheque,
			  cpdd_BancoCheque,
			  cpdd_CopiaCheque,
			  cpdd_DataPagamento,
			  cpdd_BancoPagamento,
			  cpdd_DataPreDatado,
			  cpdd_Grupo,
			  cpdd_Destinacao,
			  cpdd_Observacao)
         
         VALUES  (@Sequencia,
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
                  @Observacao)

			                
END








