
/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_DESCRICAO_INCLUIR    Script Date: 25/08/1999 20:11:32 ******/
CREATE PROCEDURE SPCP_DESCRICAO_INCLUIR

   @Codigo     smallint,
   @Tipo       char(1),
   @Descricao  char(40)

AS

BEGIN


   INSERT INTO CP_Descricao (cpde_Tipo,
                             cpde_Codigo,
                             cpde_Descricao)

                     VALUES (@Tipo,
                             @Codigo,
                             @Descricao)
                             
END	

