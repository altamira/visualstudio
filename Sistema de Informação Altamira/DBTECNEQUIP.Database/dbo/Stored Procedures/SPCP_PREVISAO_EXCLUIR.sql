
/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_EXCLUIR    Script Date: 23/10/2010 15:32:29 ******/

/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_EXCLUIR    Script Date: 16/10/01 13:41:49 ******/
/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_EXCLUIR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_PREVISAO_EXCLUIR

@Sequencia   int

AS

BEGIN

    DELETE FROM CP_Previsao 
    WHERE cppr_Sequencia = @Sequencia

END

