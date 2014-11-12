
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_ALTERAR    Script Date: 23/10/2010 15:32:31 ******/

/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_ALTERAR    Script Date: 16/10/01 13:41:45 ******/
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_ALTERAR    Script Date: 05/01/1999 11:03:44 ******/
CREATE PROCEDURE SPCP_SUBGRUPO_ALTERAR
	
	@Codigo    tinyint,
	@Descricao char(30),
   @Grupo     tinyint

AS

BEGIN

	UPDATE CP_SubGrupo
	   SET cpsg_Descricao = @Descricao,
          cpsg_Grupo = @Grupo
         WHERE cpsg_Codigo = @Codigo

END


