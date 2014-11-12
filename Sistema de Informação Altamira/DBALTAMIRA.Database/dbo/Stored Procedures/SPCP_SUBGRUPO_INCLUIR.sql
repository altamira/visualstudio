
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_INCLUIR    Script Date: 25/08/1999 20:11:40 ******/
CREATE PROCEDURE SPCP_SUBGRUPO_INCLUIR

	@Codigo    tinyint,
	@Descricao char(30),
	@Grupo     tinyint

AS

BEGIN

	INSERT INTO CP_SubGrupo (cpsg_Codigo,
			                   cpsg_Descricao,
                            cpsg_Grupo)

		      VALUES (@Codigo,
			           @Descricao,
                    @Grupo)

END

