
/****** Object:  Stored Procedure dbo.SPVE_CONFERENCIA_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPVE_CONFERENCIA_RELATORIO    Script Date: 25/08/1999 20:11:52 ******/
CREATE PROCEDURE SPVE_CONFERENCIA_RELATORIO

@DataInicial         smalldatetime,
@DataFinal           smalldatetime,  
@Representante       char(3)
      
AS
	

BEGIN

    
    SELECT vecl_Nome,
           verp_RazaoSocial,
           vepe_Pedido,
           vepe_DataPedido,
           (vepe_ValorVenda + vepe_ValorServico) 'ValorTotal',
           vepe_Comissao,
           (vepe_Comissao * (vepe_ValorVenda + vepe_ValorServico) / 100) 'ValorComissao',
           vepe_IndiceFinanceiro,
           vepe_IndiceVenda           
      
      FROM VE_Clientes,
           VE_Representantes,
           VE_Pedidos

     WHERE vepe_Representante  = @Representante
       AND vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
       AND vepe_Representante  = verp_Codigo
       AND vepe_Cliente = vecl_Codigo
          
          ORDER BY vepe_DataPedido

       
End


