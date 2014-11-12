
/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_TEXTOSPEDIDOS_VISUALIZA    Script Date: 25/08/1999 20:11:29 ******/
CREATE PROCEDURE SPVE_TEXTOSPEDIDOS_VISUALIZA
@DataInicial smalldatetime,
@DataFinal smalldatetime

AS

BEGIN

   SELECT vetx_Pedido   'Pedido',
          vetx_Item     'Item',
          vetx_dtPedido 'Data',
          vecl_Nome     'Cliente'

     FROM VE_TextosPedidos, VE_Clientes, VE_Pedidos

       WHERE vetx_dtPedido Between @DataInicial and @DataFinal
                     AND vetx_Pedido = vepe_Pedido
                     AND vepe_Cliente = vecl_Codigo

        ORDER BY vetx_dtPedido

END




