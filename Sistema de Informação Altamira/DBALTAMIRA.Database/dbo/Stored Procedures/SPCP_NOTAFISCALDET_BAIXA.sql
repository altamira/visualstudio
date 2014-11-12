
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_BAIXA    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_BAIXA    Script Date: 25/08/1999 20:11:54 ******/
CREATE PROCEDURE  SPCP_NOTAFISCALDET_BAIXA

@NumeroOP           int,
@NumeroCheque       char(15),
@BancoCheque        char(3),
@CopiaCheque        int,
@DataPagamento      smalldatetime,
@BancoPagamento     char(3),
@DataPreDatado      smalldatetime,
@Parcela  int

AS

BEGIN

	UPDATE CP_NotaFiscalDetalhe
	      
          SET cpnd_NumeroCheque = @NumeroCheque,
			  cpnd_BancoCheque = @BancoCheque,
			  cpnd_CopiaCheque = @CopiaCheque,
			  cpnd_DataPagamento = @DataPagamento,
			  cpnd_BancoPagamento = @BancoPagamento,
			  cpnd_DataPreDatado = @DataPreDatado
          
		  WHERE  cpnd_NumeroOP = @NumeroOP and
				cpnd_Parcela = @Parcela
             			                
END







