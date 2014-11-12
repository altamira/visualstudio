
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_EXCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_EXCLUIR    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPCP_TERCEIRO_EXCLUIR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_TERCEIRO_EXCLUIR  


    @Sequencia int

AS

BEGIN


    DELETE FROM CP_Terceiro
          WHERE cptr_sequencia = @Sequencia


END

