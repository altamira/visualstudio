
/****** Object:  Stored Procedure dbo.SPCO_USINA_EXCLUIR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE SPCO_USINA_EXCLUIR
	(@Pedido  char(14),
	 @Bobina char(14))

AS 
DELETE From CO_Usina
WHERE 
	(cous_Pedido		= @Pedido and 
	 cous_CodBobina	= @Bobina)




