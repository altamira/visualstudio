
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_BAIXA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_BAIXA    Script Date: 25/08/1999 20:11:47 ******/
CREATE PROCEDURE  SPCP_DESPESAIMPOSTODET_BAIXA

@NumeroOP           int,
@NumeroCheque       char(15),
@BancoCheque        char(3),
@CopiaCheque        int,
@DataPagamento      smalldatetime,
@BancoPagamento     char(3),
@DataPreDatado      smalldatetime

AS

BEGIN

	UPDATE CP_DespesaImpostoDetalhe
	      SET cpdd_NumeroCheque = @NumeroCheque,
			  cpdd_BancoCheque = @BancoCheque,
			  cpdd_CopiaCheque = @CopiaCheque,
			  cpdd_DataPagamento = @DataPagamento,
			  cpdd_BancoPagamento = @BancoPagamento,
			  cpdd_DataPreDatado = @DataPreDatado
          
		 WHERE cpdd_NumeroOP = @NumeroOP
          			                
END








