-- ===================================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description: Retorna  porcentagem total produzida
--				do pedido de venda por operação
-- ===================================================
CREATE FUNCTION [dbo].[GPFN_RetornarPorcentagemProduzidoDaSituacaoDoPedidoDeVenda]
(
	-- Parâmetros
	@Empresa			NVARCHAR(02),
	@PedidoDeVenda		INT,
	@Situacao			SMALLINT
)
RETURNS MONEY
AS
BEGIN
	-- Delcare a variável de retorno aqui
	DECLARE @DataNulaGPIMAC				DATETIME
	DECLARE @PorcentagemTotalProduzido	MONEY
	DECLARE @DataSituacao				DATETIME

	SET @DataNulaGPIMAC   = CAST('1753-01-01' AS DATETIME )

	-- Pegar a Data da situação do Pedido de Venda
	SET @DataSituacao				= @DataNulaGPIMAC
	SET @PorcentagemTotalProduzido	= 0
	SELECT TOP 01
		@DataSituacao	= ISNULL(LPEt2IniDat, @DataNulaGPIMAC )
	FROM LPVSITETAPA
	WHERE	LPEMP		= @Empresa
	AND		LPPED		= @PedidoDeVenda
	AND		LPEt2Seq	= @Situacao

	IF @DataSituacao = @DataNulaGPIMAC
		SET @PorcentagemTotalProduzido = 0
		
	ELSE
	BEGIN
		IF @Situacao = 10
			SET @PorcentagemTotalProduzido = 100
			
		ELSE IF @Situacao = 30
			SET @PorcentagemTotalProduzido = dbo.GPFN_RetornarPorcentagemProduzidoDaOperacaoDoPedidoDeVenda(@Empresa, @PedidoDeVenda, 'ESTAMP' )
			
		ELSE IF @Situacao = 40
			SET @PorcentagemTotalProduzido = dbo.GPFN_RetornarPorcentagemProduzidoDaOperacaoDoPedidoDeVenda(@Empresa, @PedidoDeVenda, 'PINT'   )
			
		ELSE IF @Situacao = 60
			SET @PorcentagemTotalProduzido = dbo.GPFN_RetornarPorcentagemProduzidoDaOperacaoDoPedidoDeVenda(@Empresa, @PedidoDeVenda, 'EXPED'  )
			
		ELSE
			SET @PorcentagemTotalProduzido = 0
			
	END
    
    IF @PorcentagemTotalProduzido = NULL
		SET @PorcentagemTotalProduzido = 0
		
	-- Retornar o Resultado da Função
	RETURN @PorcentagemTotalProduzido

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarPorcentagemProduzidoDaSituacaoDoPedidoDeVenda] TO [interclick]
    AS [dbo];

