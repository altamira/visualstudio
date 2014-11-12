
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_GRUPO_ALTERAR    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCP_GRUPO_ALTERAR
	
	@CodigoGrupo    tinyint,
	@DescricaoGrupo char(30)

AS

BEGIN

	UPDATE CP_Grupo
	   SET cpgr_DescricaoGrupo = @DescricaoGrupo
         WHERE cpgr_CodigoGrupo = @CodigoGrupo

END


