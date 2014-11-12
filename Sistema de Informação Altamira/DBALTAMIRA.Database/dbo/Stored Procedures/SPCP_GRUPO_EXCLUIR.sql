
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_GRUPO_EXCLUIR    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCP_GRUPO_EXCLUIR

	@CodigoGrupo   tinyint

AS

BEGIN

	DELETE FROM CP_Grupo
	      WHERE cpgr_CodigoGrupo = @CodigoGrupo

END


