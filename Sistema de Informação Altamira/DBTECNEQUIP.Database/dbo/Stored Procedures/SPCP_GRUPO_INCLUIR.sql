
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_INCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_GRUPO_INCLUIR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_GRUPO_INCLUIR    Script Date: 05/01/1999 11:03:43 ******/
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

