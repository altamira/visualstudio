
/****** Object:  Stored Procedure dbo.SPCO_USINA_VISUALIZA    Script Date: 23/10/2010 13:58:21 ******/


/***** Object:  Stored Procedure SPCO_USINA_VISUALIZA    Script Date: 24/03/2000 15:34:00 ******/
CREATE PROCEDURE SPCO_USINA_VISUALIZA

AS

BEGIN

   SELECT cous_Pedido as 'Pedido',cous_DataPedido as 'Data',cous_CodBobina as 'Bobina',cous_Decendio as 'Decendio'
     FROM CO_Usina
 ORDER BY cous_Pedido

END

