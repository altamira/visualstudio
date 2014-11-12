
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_ALTERAR    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_ALTERAR    Script Date: 16/10/01 13:41:41 ******/
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_ALTERAR    Script Date: 05/01/1999 11:03:43 ******/
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







