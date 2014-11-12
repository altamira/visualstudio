
/****** Object:  Stored Procedure dbo.SPCO_USINA_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE [SPCO_USINA_ALTERAR]
	 @CodFornecedor 	char(14),
	 @CodBobina 	    	char(14),
	 @NormaDoAco 	int,
	 @TipoDoAco	 	int,
	 @Acabamento 		int,
	 @Espessura	 	int,
	 @Largura	 	numeric,
	 @Peso     	 	numeric,
	 @Pedido                        char(14),
	 @DataPedido     	smalldatetime,
	 @Decendio	 	text,
	@MesDecendio		char

AS UPDATE  CO_Usina

SET       cous_TipoDoAco	 	= @TipoDoAco,
	 cous_Acabamento	 	= @Acabamento,
	 cous_Espessura		= @Espessura,
	 cous_Largura	 		= @Largura,
	 cous_Peso     			= @Peso,
	 cous_Pedido         		= @Pedido,
	 cous_DataPedido  		= @DataPedido,
	 cous_Decendio  		= @Decendio,
	 cous_MesDecendio		= @MesDecendio,
               cous_NormaDoAco		= @NormaDoAco

WHERE (cous_Pedido   	 	= @Pedido And
               cous_CodFornecedor    = @CodFornecedor And
               cous_CodBobina           = @CodBobina)



