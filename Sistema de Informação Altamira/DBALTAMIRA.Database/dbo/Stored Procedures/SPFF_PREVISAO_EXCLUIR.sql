
/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_EXCLUIR    Script Date: 25/08/1999 20:11:34 ******/
/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_EXCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_PREVISAO_EXCLUIR

@Sequencia   int

AS

BEGIN

    DELETE FROM FF_Previsao 
    WHERE ffpr_Sequencia = @Sequencia

END


