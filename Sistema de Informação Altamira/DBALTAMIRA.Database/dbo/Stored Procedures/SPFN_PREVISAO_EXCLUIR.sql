
/****** Object:  Stored Procedure dbo.SPFN_PREVISAO_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_PREVISAO_EXCLUIR    Script Date: 25/08/1999 20:11:36 ******/
CREATE PROCEDURE SPFN_PREVISAO_EXCLUIR

@Sequencia   int

AS

BEGIN

    DELETE FROM FN_Previsao 
    WHERE fnpr_Sequencia = @Sequencia

END

