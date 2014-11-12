-- =============================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna o peso total da operação de produção 
--				realizado par um determinado item do 
--				pedido de venda
-- =============================================
CREATE FUNCTION [dbo].[GPFN_RetornarPesoTotalProduzidoDaOperacaoDoDoPedidoDeVenda]
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
	DECLARE @PesoTotalProduzido	MONEY

	-- Add the T-SQL statements to compute the return value here
    SET @PesoTotalProduzido = dbo.GPFN_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda(@Empresa, @PedidoDeVenda, 0, @Operacao )
    
	-- Retornar o Resultado da Função
	RETURN @PesoTotalProduzido

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarPesoTotalProduzidoDaOperacaoDoDoPedidoDeVenda] TO [interclick]
    AS [dbo];

