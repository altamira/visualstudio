
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_EXCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_EXCLUIR    Script Date: 25/08/1999 20:11:39 ******/
CREATE PROCEDURE SPCP_SUBGRUPO_EXCLUIR

	@Codigo   tinyint

AS

BEGIN

	DELETE FROM CP_SubGrupo
	      WHERE cpsg_Codigo = @Codigo

END


