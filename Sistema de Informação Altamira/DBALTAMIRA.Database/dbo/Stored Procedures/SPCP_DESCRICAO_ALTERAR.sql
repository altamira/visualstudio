
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_ALTERAR    Script Date: 25/08/1999 20:11:31 ******/
CREATE PROCEDURE SPCP_DESCRICAO_ALTERAR

   @Codigo     smallint,
   @Tipo       char(1),
   @Descricao  char(40)

AS

BEGIN


   UPDATE CP_Descricao 
      SET cpde_Descricao = @Descricao
    WHERE cpde_Codigo    = @Codigo
      AND cpde_Tipo      = @Tipo


END







