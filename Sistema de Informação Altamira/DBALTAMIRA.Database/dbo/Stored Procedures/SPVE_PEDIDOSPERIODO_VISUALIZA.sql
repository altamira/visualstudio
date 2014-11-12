
/****** Object:  Stored Procedure dbo.SPVE_PEDIDOSPERIODO_VISUALIZA    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPVE_PEDIDOSPERIODO_VISUALIZA    Script Date: 10/02/2000 10:40:00 ******/
CREATE PROCEDURE SPVE_PEDIDOSPERIODO_VISUALIZA

@DataInicial smalldatetime,
@DataFinal smalldatetime


AS

BEGIN

   SELECT vepe_Pedido     'Pedido',
          vepe_DataPedido 'Data',
          vecl_Nome       'Cliente'
          
     FROM VE_Pedidos, VE_Representantes,VE_Clientes

       WHERE vepe_DataPedido BetWeen @DataInicial And @DataFinal And
                      verp_Codigo = vepe_representante And
                       vecl_Codigo = vepe_Cliente 
                      

        ORDER BY vepe_DataPedido

END




