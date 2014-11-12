-- =============================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna o peso total da operação de produção 
--				realizado par um determinado item do 
--				pedido de venda
-- =============================================
CREATE FUNCTION [dbo].[GPFN_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda]
(
	-- Parâmetros
	@Empresa			NVARCHAR(02),
	@PedidoDeVenda		INT,
	@ItemPedidoDeVenda	SMALLMONEY,
	@Operacao			NVARCHAR(08)
)
RETURNS MONEY
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PesoTotalProduzido	MONEY
	DECLARE @PesoUnitario		MONEY

	-- Add the T-SQL statements to compute the return value here
    SET @PesoTotalProduzido = 0
   
    
    IF ISNULL(@ItemPedidoDeVenda, 0 ) > 0
    BEGIN
		-- Retornar o peso total produzido para apenas um item do pedido de venda
		SELECT		
			@PesoTotalProduzido = SUM(ROUND((CPROPES * OPR2BaiQtd), 3))
		FROM		OPROMITEMBAIXA
		INNER JOIN  OPROM
			ON	OPROM.OPR0Emp				= OPROMITEMBAIXA.OPR0Emp
			AND	OPROM.OPR0Cod				= OPROMITEMBAIXA.OPR0Cod
		INNER JOIN  OPROMITEM
			ON	OPROMITEM.OPR0Emp			= OPROMITEMBAIXA.OPR0Emp
			AND	OPROMITEM.OPR0Cod			= OPROMITEMBAIXA.OPR0Cod
			AND OPROMITEM.OPR1OPEmp			= OPROMITEMBAIXA.OPR1OPEmp
			AND OPROMITEM.OPR1OPCod			= OPROMITEMBAIXA.OPR1OPCod
			AND OPROMITEM.OPR1CPbCod		= OPROMITEMBAIXA.OPR1CPbCod
		INNER JOIN	CAPRO
			ON	OPROMITEMBAIXA.OPR1CPbCod	= CAPRO.CPROCOD
			WHERE	OPROM.OPR0CSerCod		= @Operacao
			AND		OPROMITEM.OPR1LPEMP		= @Empresa
			AND		OPROMITEM.OPR1LPPed		= @PedidoDeVenda
			AND		OPROMITEM.OPR1LpSeq		= @ItemPedidoDeVenda
	END -- IF ISNULL(@ItemPedidoDeVenda, 0 ) > 0
	ELSE
	BEGIN
		-- Retornar o peso total produzido de todos os itens do pedido de venda
		SELECT		
			@PesoTotalProduzido = SUM(ROUND((CPROPES * OPR2BaiQtd), 3))
		FROM		OPROMITEMBAIXA
		INNER JOIN  OPROM
			ON	OPROM.OPR0Emp				= OPROMITEMBAIXA.OPR0Emp
			AND	OPROM.OPR0Cod				= OPROMITEMBAIXA.OPR0Cod
		INNER JOIN  OPROMITEM
			ON	OPROMITEM.OPR0Emp			= OPROMITEMBAIXA.OPR0Emp
			AND	OPROMITEM.OPR0Cod			= OPROMITEMBAIXA.OPR0Cod
			AND OPROMITEM.OPR1OPEmp			= OPROMITEMBAIXA.OPR1OPEmp
			AND OPROMITEM.OPR1OPCod			= OPROMITEMBAIXA.OPR1OPCod
			AND OPROMITEM.OPR1CPbCod		= OPROMITEMBAIXA.OPR1CPbCod
		INNER JOIN	CAPRO
			ON	OPROMITEMBAIXA.OPR1CPbCod	= CAPRO.CPROCOD
			WHERE	OPROM.OPR0CSerCod		= @Operacao
			AND		OPROMITEM.OPR1LPEMP		= @Empresa
			AND		OPROMITEM.OPR1LPPed		= @PedidoDeVenda
	
	END -- ELSE DO IF ISNULL(@ItemPedidoDeVenda, 0 ) > 0	

	IF @PesoTotalProduzido = NULL
		SET @PesoTotalProduzido = 0
		
	-- Retornar o Resultado da Função
	RETURN @PesoTotalProduzido

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda] TO [interclick]
    AS [dbo];

