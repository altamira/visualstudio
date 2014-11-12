
/****** Object:  Stored Procedure dbo.SPVE_COMISSAOINDIV_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_COMISSAOINDIV_CONSULTA    Script Date: 25/08/1999 20:11:28 ******/
CREATE PROCEDURE SPVE_COMISSAOINDIV_CONSULTA

@DataInicial     smalldatetime,
@DataFinal       smalldatetime,
@Representante   char(3)

AS

BEGIN

   SELECT vepe_Pedido,
          vepe_DataPedido,
          vepe_ValorVenda,
          (vepe_Comissao * vepe_ValorVenda / 100) 'Comissao',
          vecl_Nome

      FROM  VE_Pedidos, 
            VE_ClientesNovo

        WHERE  vepe_Cliente = vecl_Codigo
          AND  vepe_DataPedido Between @DataInicial AND @DataFinal
          AND  vepe_Representante = @Representante

END
	


