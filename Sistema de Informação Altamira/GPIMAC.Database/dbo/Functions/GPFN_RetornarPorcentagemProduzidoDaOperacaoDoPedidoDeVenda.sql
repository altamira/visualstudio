-- ===================================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna  porcentagem total produzida
--				do pedido de venda por operação
-- ===================================================
CREATE FUNCTION [dbo].[GPFN_RetornarPorcentagemProduzidoDaOperacaoDoPedidoDeVenda]
(
	-- Parâmetros
	@Empresa			NVARCHAR(02),
	@PedidoDeVenda		INT,
	@Operacao			NVARCHAR(08)
)
RETURNS MONEY
AS
BEGIN
	-- Delcare a variável de retorno aqui
	DECLARE @PorcentagemTotalProduzido	MONEY
	DECLARE @PesoTotalPedidoDeVenda		MONEY
	DECLARE @PesoTotalProduzido			MONEY

	SET @PorcentagemTotalProduzido = 0
	SET @PesoTotalPedidoDeVenda    = dbo.GPFN_RetornarPesoTotalDoDoPedidoDeVenda(@Empresa, @PedidoDeVenda )
    SET @PesoTotalProduzido        = dbo.GPFN_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda(@Empresa, @PedidoDeVenda, 0, @Operacao )
    
    -- round(((Lp0PesPrd*100)/Lp0PesTot),3)IFLp0PesTot>0;0OTHERWISE
    IF @PesoTotalPedidoDeVenda > 0
		BEGIN
		SET @PorcentagemTotalProduzido = ROUND((( @PesoTotalProduzido * 100 ) / @PesoTotalPedidoDeVenda),3)
		IF @PorcentagemTotalProduzido >= 90
			BEGIN
			SET @PorcentagemTotalProduzido = 100
		END
		
    END -- IF @PesoTotalProduzido > 0
    ELSE
		BEGIN
		SET @PorcentagemTotalProduzido = 0
	END
    
    IF @PorcentagemTotalProduzido = NULL
		SET @PorcentagemTotalProduzido = 0
		
	-- Retornar o Resultado da Função
	RETURN @PorcentagemTotalProduzido

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarPorcentagemProduzidoDaOperacaoDoPedidoDeVenda] TO [interclick]
    AS [dbo];

