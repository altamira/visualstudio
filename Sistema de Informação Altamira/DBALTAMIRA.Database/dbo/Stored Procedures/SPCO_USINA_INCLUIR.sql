
/****** Object:  Stored Procedure dbo.SPCO_USINA_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE [SPCO_USINA_INCLUIR]
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
	 @MesDecendio	Char(2)

AS BEGIN
INSERT INTO   CO_Usina
( 	 cous_CodFornecedor,
	 cous_CodBobina,
	 cous_NormaDoAco,
	 cous_TipoDoAco,
	 cous_Acabamento,
	 cous_Espessura,
	 cous_Largura,
	 cous_Peso,
	 cous_Pedido,
	 cous_DataPedido,
	 cous_Decendio,
	 cous_MesDecendio)

VALUES (@CodFornecedor,
	 @CodBobina,
	 @NormaDoAco,
	 @TipoDoAco,
	 @Acabamento,
	 @Espessura,
	 @Largura,
	 @Peso,
	 @Pedido,
	 @DataPedido,
	 @Decendio,
	 @MesDecendio)
END






