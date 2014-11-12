
-- =============================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna o peso total da operação de produção 
--				realizado par um determinado item do 
--				pedido de venda
-- =============================================
CREATE FUNCTION [dbo].[GPFN_RetornarPesoTotalDoDoPedidoDeVenda]
(
	-- Parâmetros
	@Empresa			NVARCHAR(02),
	@PedidoDeVenda		INT
)
RETURNS MONEY
AS
BEGIN
	-- Declare a variável de retorno aqui.
	DECLARE @PesoTotal			MONEY
	
    SELECT 
		@PesoTotal = SUM(dbo.GPFN_RetornarPesoTotalDoItemDoPedidoDeVenda(LPEMP, LPPED, LPSEQ ) )
	FROM	LPV1
	WHERE	LPV1.LPEMP          = @Empresa
	AND		LPV1.LPPED          = @PedidoDeVenda
    AND     LPV1.LPWBCCADORCITM > 0
    AND     LPV1.LPWBCCADGRPCOD > 0    
    
    IF @PesoTotal = NULL	
		SET @PesoTotal = 0
		
	-- Retornar o Resultado da Função
	RETURN @PesoTotal

END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarPesoTotalDoDoPedidoDeVenda] TO [interclick]
    AS [dbo];

