-- =============================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna o peso total da operação de produção 
--				realizado par um determinado item do 
--				pedido de venda
-- =============================================
CREATE FUNCTION [dbo].[GPFN_RetornarPesoTotalDoItemDoPedidoDeVenda]
(
	-- Parâmetros
	@Empresa			NVARCHAR(02),
	@PedidoDeVenda		INT,
	@ItemPedidoDeVenda	SMALLMONEY
)
RETURNS MONEY
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PesoTotal			MONEY
	DECLARE @Quantidade_Pedido	MONEY
	DECLARE @ProdutoCodigo		NVARCHAR(60)
	
    SET @PesoTotal			= 0
    SET @ProdutoCodigo		= ''
    SET @Quantidade_Pedido	= 1 -- NÃO PEGAR A QUANTIDADE DO PEDIDO DE VENDA PARAM ULTIPLICAR (EXCLUSIVO ALTAMIRA)
    
    
	-- Retornar o peso total produzido de todos os itens do pedido de venda
	SELECT TOP 01
		@ProdutoCodigo = CPROCOD
	FROM	LPV1
	WHERE	LPV1.LPEMP = @Empresa
	AND		LPV1.LPPED = @PedidoDeVenda
	AND		LPV1.LPSEQ = @ItemPedidoDeVenda
	
	IF @ProdutoCodigo <> ''
		BEGIN
	
			SELECT 
				@PesoTotal = SUM(ROUND((CPROPES * CPBQtd) , 10 ))
			FROM		CAPROEP
			INNER JOIN	CAPROEPSPR
			ON			CAPROEP.CPROCOD		= CAPROEPSPR.CPROCOD
			AND         CAPROEP.CPRO1EPPad	= 1
			INNER JOIN  CAPRO AS SUBPRODUTO
			ON			CAPROEPSPR.CPBCod	= SUBPRODUTO.CPROCOD
			WHERE       CAPROEP.CPROCOD		= @ProdutoCodigo
			
			
			SET @PesoTotal = ROUND((@PesoTotal * @Quantidade_Pedido), 3 )
	END
			
	IF @PesoTotal = NULL
		SET @PesoTotal = 0

		-- Retornar o Resultado da Função
	RETURN @PesoTotal

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarPesoTotalDoItemDoPedidoDeVenda] TO [interclick]
    AS [dbo];

