
/****** Object:  Stored Procedure dbo.SPVE_CLIENTESREPR_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_CLIENTESREPR_RELATORIO    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE SPVE_CLIENTESREPR_RELATORIO

@Representante      char(3)

AS
	SELECT vecl_Codigo,
           vecl_Nome,
           vecl_Contato,
           vecl_DDD,
           vecl_Telefone
           
            FROM VE_ClientesNovo

       WHERE vecl_Representante = @Representante


