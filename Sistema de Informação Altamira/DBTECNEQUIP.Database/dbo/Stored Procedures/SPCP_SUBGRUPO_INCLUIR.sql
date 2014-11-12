
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_INCLUIR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_INCLUIR    Script Date: 16/10/01 13:41:45 ******/
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_INCLUIR    Script Date: 05/01/1999 11:03:44 ******/
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

