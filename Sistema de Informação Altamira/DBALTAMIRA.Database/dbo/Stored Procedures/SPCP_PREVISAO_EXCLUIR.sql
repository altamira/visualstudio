
/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_EXCLUIR    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_PREVISAO_EXCLUIR

@Sequencia   int

AS

BEGIN

    DELETE FROM CP_Previsao 
    WHERE cppr_Sequencia = @Sequencia

END

