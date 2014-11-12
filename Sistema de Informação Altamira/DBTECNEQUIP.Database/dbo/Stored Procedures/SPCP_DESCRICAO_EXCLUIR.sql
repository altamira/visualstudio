
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_EXCLUIR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_EXCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_DESCRICAO_EXCLUIR

   @Codigo     smallint

AS

BEGIN


   DELETE FROM CP_Descricao 
         WHERE cpde_Codigo = @Codigo



END


