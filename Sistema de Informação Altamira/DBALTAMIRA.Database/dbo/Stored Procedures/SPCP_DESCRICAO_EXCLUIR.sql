
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_EXCLUIR    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCP_DESCRICAO_EXCLUIR

   @Codigo     smallint

AS

BEGIN


   DELETE FROM CP_Descricao 
         WHERE cpde_Codigo = @Codigo



END


