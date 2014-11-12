
/****** Object:  Stored Procedure dbo.SPCO_BOBINA_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE [SPCO_BOBINA_ALTERAR]
	 @CodFornecedor 	char(14),
	 @CodPrestador 	char(14),
	 @CodBobina 	    	char(14),
	 @NumeroDaCorrida 	char(15),
	 @NormaDoAco 	char(40),
	 @TipoDoAco	 	char(8),
	 @Acabamento 		char(40),
	 @Espessura	 	char(10),
	 @Largura	 	float,
	 @PesoTotal	 	float,
	 @PedidoUsina               char(14),
	 @DataEntrega  	smalldatetime,
	 @Observacao	 	text,
	 @SaldoTonelada 	float,
	 @SaldoLargura 	float

AS UPDATE  CO_Bobina 

SET       CodFornecedor 		= @CodFornecedor,
	 CodPrestador	 	= @CodPrestador,
	 CodBobina	 	= @CodBobina,
	 NumeroDaCorrida	= @NumeroDaCorrida,
	 NormaDoAco	 	= @NormaDoAco,
	 TipoDoAco	 	= @TipoDoAco,
	 Acabamento	 	= @Acabamento,
	 Espessura		= @Espessura,
	 Largura	 		= @Largura,
	 PesoTotal		= @PesoTotal,
	 PedidoUsina    		= @PedidoUsina,
	 DataEntrega 		= @DataEntrega,
	 Observacao		= @Observacao,
	 SaldoTonelada		= @SaldoTonelada,
	 SaldoLargura		= @SaldoLargura
WHERE 
	( CodBobina	 	= @CodBobina)




