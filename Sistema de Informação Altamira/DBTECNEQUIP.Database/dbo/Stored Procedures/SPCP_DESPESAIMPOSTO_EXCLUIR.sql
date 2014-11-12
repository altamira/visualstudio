
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_EXCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_EXCLUIR    Script Date: 16/10/01 13:41:47 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_DESPESAIMPOSTO_EXCLUIR

@Sequencia        int

AS

BEGIN

	DELETE FROM CP_DespesaImpostoDetalhe
	      WHERE cpdd_Sequencia = @Sequencia
		    
    DELETE FROM CP_DespesaImposto
	      WHERE cpdi_Sequencia = @Sequencia

END


