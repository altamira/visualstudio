
/****** Object:  Stored Procedure dbo.SPCO_BOBINA_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/

CREATE PROCEDURE SPCO_BOBINA_INCLUIR 

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
	 @PedidoUsina	 	char(14),
	 @DataEntrega  	smalldatetime,
	 @Observacao	 	text,
	 @SaldoTonelada 	float,
	 @SaldoLargura 	float

AS
BEGIN
    INSERT INTO CO_Bobina 
	 ( CodFornecedor,
	 CodPrestador,
	 CodBobina,
	 NumeroDaCorrida,
	 NormaDoAco,
	 TipoDoAco,
	 Acabamento,
	 Espessura,
	 Largura,
	 PesoTotal,
	 PedidoUsina,
	 DataEntrega,
	 Observacao,
	 SaldoTonelada,
	 SaldoLargura) 
VALUES 
	( @CodFornecedor,
	 @CodPrestador,
	 @CodBobina,
	 @NumeroDaCorrida,
	 @NormaDoAco,
	 @TipoDoAco,
	 @Acabamento,
	 @Espessura,
	 @Largura,
	 @PesoTotal,
	 @PedidoUsina,
	 @DataEntrega,
	 @Observacao,
	 @SaldoTonelada,
	 @SaldoLargura)
END


