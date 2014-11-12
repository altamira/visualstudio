
/****** Object:  Stored Procedure dbo.SPVE_VENDASMENSAIS_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_VENDASMENSAIS_RELATORIO    Script Date: 25/08/1999 20:11:37 ******/
CREATE PROCEDURE SPVE_VENDASMENSAIS_RELATORIO

@DataInicial     smalldatetime,
@DataFinal       smalldatetime,
@Representante   char(3)

AS
	
Begin

   
    SELECT vepe_Pedido,
           vepe_DataPedido,
           vepe_ValorVenda,
           vepe_Comissao,
          (vepe_Comissao * vepe_ValorVenda / 100) 'Comissao',
           vecl_Nome,
           vepe_IndiceFinanceiro,
           vepe_IndiceVenda,
           verp_RazaoSocial


      FROM  VE_Pedidos, 
            VE_ClientesNovo,
            VE_Representantes

        WHERE vepe_Representante =  @Representante
         AND  vepe_DataPedido Between @DataInicial AND @DataFinal
         AND  vepe_Cliente = vecl_Codigo
         AND  vepe_Representante = verp_Codigo

         
End



