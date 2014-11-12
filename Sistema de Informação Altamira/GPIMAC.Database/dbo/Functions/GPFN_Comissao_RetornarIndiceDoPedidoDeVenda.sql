-- =============================================
-- Author:		Denis André
-- Create date: 08/11/2012
-- Description:	Retorna um índice da diferença 
--              entre o total do pedido e o
--              total dos impostos agregados
-- =============================================
CREATE FUNCTION GPFN_Comissao_RetornarIndiceDoPedidoDeVenda
(
	-- Parâmetros da Função
	@Empresa			NVARCHAR(02),
	@PedidoDeVenda		INT
)
RETURNS DECIMAL(15,10)  --99999.9999999999
AS
BEGIN
	-- Declaração da variável de retorno da função
	DECLARE @Ret_IndiceDoPedidoDeVenda	DECIMAL(15,10)
	SET     @Ret_IndiceDoPedidoDeVenda  = 1
	
	-- Abaixo: Comandos para retornar o resultado desejado:
	DECLARE @TotalDosProdutos			MONEY,
			@TotalDoPedido				MONEY
	
	SET		@TotalDosProdutos			= 0
	SET		@TotalDoPedido				= 0
	
	SELECT	TOP 01
		@TotalDosProdutos		= dbo.LPV.LPTGERed,	
		@TotalDoPedido			= dbo.LPV.LPTOTPedRed
	FROM dbo.LPV
		WHERE	dbo.LPV.LPEMP		= @Empresa
		and		dbo.LPV.LPPED		= @PedidoDeVenda
	IF @@ROWCOUNT > 0
		BEGIN
			IF @TotalDoPedido > 0
				SET @Ret_IndiceDoPedidoDeVenda = ROUND((@TotalDosProdutos / @TotalDoPedido), 10)
			ELSE
				BEGIN
					SET @TotalDoPedido				= 0
					SET @TotalDosProdutos			= 0
					SET @Ret_IndiceDoPedidoDeVenda	= 1
				END
			-- ENDIF @TotalDoPedido > 0
		END
	ELSE
		BEGIN
			SET @TotalDoPedido				= 0
			SET @TotalDosProdutos			= 0
			SET @Ret_IndiceDoPedidoDeVenda	= 1
		END
	-- ENDIF @@ROWCOUNT > 0

	-- Return the result of the function
	RETURN @Ret_IndiceDoPedidoDeVenda

END

GO
GRANT REFERENCES
    ON OBJECT::[dbo].[GPFN_Comissao_RetornarIndiceDoPedidoDeVenda] TO [interclick]
    AS [dbo];

