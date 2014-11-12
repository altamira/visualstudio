
/****** Object:  Stored Procedure dbo.SPCO_BOBINA_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/***** Object:  Stored Procedure SPCO_BOBINA_VISUALIZA    Script Date: 14/03/2000 15:34:00 ******/
CREATE PROCEDURE SPCO_BOBINA_VISUALIZA

AS

BEGIN

   SELECT CodBobina as 'Bobina',NumeroDaCorrida as 'N.Corrida',PedidoUsina as 'Pedido',DataEntrega as 'Entrega'
     FROM CO_Bobina
 ORDER BY CodBobina

END




