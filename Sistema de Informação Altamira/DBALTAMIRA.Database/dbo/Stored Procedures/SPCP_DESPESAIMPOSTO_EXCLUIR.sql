
/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESPESAIMPOSTO_EXCLUIR    Script Date: 25/08/1999 20:11:22 ******/
CREATE PROCEDURE SPCP_DESPESAIMPOSTO_EXCLUIR

@Sequencia        int

AS

BEGIN

	DELETE FROM CP_DespesaImpostoDetalhe
	      WHERE cpdd_Sequencia = @Sequencia
		    
    DELETE FROM CP_DespesaImposto
	      WHERE cpdi_Sequencia = @Sequencia

END


