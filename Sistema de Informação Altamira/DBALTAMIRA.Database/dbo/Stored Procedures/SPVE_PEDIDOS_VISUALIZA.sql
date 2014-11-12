
/****** Object:  Stored Procedure dbo.SPVE_PEDIDOS_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_PEDIDOS_VISUALIZA    Script Date: 25/08/1999 20:11:28 ******/
CREATE PROCEDURE SPVE_PEDIDOS_VISUALIZA

AS

BEGIN

   SELECT vepe_Pedido     'Pedido',
          vepe_DataPedido 'Data',
          vecl_Nome       'Cliente'
          
     FROM VE_Pedidos, VE_Clientes

       WHERE vepe_Cliente = vecl_Codigo

        ORDER BY vepe_Pedido

END

