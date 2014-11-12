
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_GRUPO_INCLUIR    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCP_GRUPO_INCLUIR

	@CodigoGrupo    tinyint,
	@DescricaoGrupo char(30)

AS

BEGIN

	INSERT INTO CP_Grupo (cpgr_CodigoGrupo,
			      cpgr_DescricaoGrupo)

		      VALUES (@CodigoGrupo,
			      @DescricaoGrupo)

END

