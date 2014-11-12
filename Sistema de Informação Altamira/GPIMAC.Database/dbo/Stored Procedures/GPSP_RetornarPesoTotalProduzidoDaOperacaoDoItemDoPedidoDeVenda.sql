-- ==========================================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna o peso total da operação de produção 
--				realizado par um determinado item do 
--				pedido de venda
-- ==========================================================
CREATE PROCEDURE [dbo].[GPSP_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda]
	-- Parâmetros
	@Empresa			NVARCHAR(02)	OUTPUT,
	@PedidoDeVenda		INT				OUTPUT,
	@ItemPedidoDeVenda	SMALLMONEY		OUTPUT,
	@Operacao			NVARCHAR(08)	OUTPUT,
	@PesoTotalProduzido	MONEY			OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

    SET @PesoTotalProduzido = dbo.GPFN_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda(@Empresa, @PedidoDeVenda, @ItemPedidoDeVenda, @Operacao )
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarPesoTotalProduzidoDaOperacaoDoItemDoPedidoDeVenda] TO [interclick]
    AS [dbo];

