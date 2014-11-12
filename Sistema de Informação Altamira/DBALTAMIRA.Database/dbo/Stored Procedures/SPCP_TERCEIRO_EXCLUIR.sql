
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_EXCLUIR    Script Date: 25/08/1999 20:11:24 ******/
CREATE PROCEDURE SPCP_TERCEIRO_EXCLUIR  


    @Sequencia int

AS

BEGIN


    DELETE FROM CP_Terceiro
          WHERE cptr_sequencia = @Sequencia


END

