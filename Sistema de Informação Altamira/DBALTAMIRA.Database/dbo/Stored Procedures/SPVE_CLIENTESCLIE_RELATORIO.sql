
/****** Object:  Stored Procedure dbo.SPVE_CLIENTESCLIE_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_CLIENTESCLIE_RELATORIO    Script Date: 25/08/1999 20:11:36 ******/
CREATE PROCEDURE SPVE_CLIENTESCLIE_RELATORIO

@Codigo      char(14)

AS
	SELECT VE_ClientesNovo.*,
           vetr_Nome,
           verp_RazaoSocial
           
            FROM VE_ClientesNovo,
                 VE_Transportadoras,
                 VE_Representantes

       WHERE vecl_Codigo = @Codigo
         AND vetr_Codigo = vecl_Transportadora
         AND verp_Codigo = vecl_Representante


