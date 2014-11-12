
/****** Object:  Stored Procedure dbo.SPVE_REPRESINDIVID_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_REPRESINDIVID_RELATORIO    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_REPRESINDIVID_RELATORIO

@RazaoSocial     varchar(50)

AS

BEGIN

   SELECT * FROM VE_Representantes
          
     Where verp_RazaoSocial = @RazaoSocial

END

