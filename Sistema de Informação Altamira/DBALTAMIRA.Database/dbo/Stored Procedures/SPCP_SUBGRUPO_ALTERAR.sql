
/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_SUBGRUPO_ALTERAR    Script Date: 25/08/1999 20:11:39 ******/
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


