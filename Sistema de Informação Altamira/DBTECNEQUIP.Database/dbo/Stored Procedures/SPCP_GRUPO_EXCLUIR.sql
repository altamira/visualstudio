
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_EXCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_GRUPO_EXCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_EXCLUIR    Script Date: 05/01/1999 11:03:43 ******/
CREATE PROCEDURE SPCP_GRUPO_EXCLUIR

	@CodigoGrupo   tinyint

AS

BEGIN

	DELETE FROM CP_Grupo
	      WHERE cpgr_CodigoGrupo = @CodigoGrupo

END


