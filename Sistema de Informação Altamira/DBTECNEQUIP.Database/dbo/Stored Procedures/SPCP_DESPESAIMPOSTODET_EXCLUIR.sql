
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_EXCLUIR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_EXCLUIR    Script Date: 16/10/01 13:41:48 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTODET_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_DESPESAIMPOSTODET_EXCLUIR

@Sequencia        int

AS

BEGIN

	DELETE FROM CP_DespesaImpostoDetalhe
	      WHERE cpdd_Sequencia = @Sequencia
		    
END


