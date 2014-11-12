
-- ========================================================================================================================================
-- Author:		Denis André
-- Create date: 10/10/2012
-- Description:	Função responsável por retornar o Extrato de valores do pedido de venda (Débitos) e as baixas realizadas (créditos)
--              Pensar: Valor da Comissão
-- ========================================================================================================================================
CREATE FUNCTION [dbo].[GPFN_RetornarExtratoPedidoDeVenda]
(
	-- Parâmetros de entrada da função
	@PedidoEmpresa	NVARCHAR(02),
	@PedidoNumero	INT
)
RETURNS 

@tExtratoPedido TABLE 
(
	-- Colunas da tabela (em memória)
	Id								INT				IDENTITY(1,1) NOT NULL,
	Empresa							NVARCHAR(02)	NOT NULL,
	Origem							NVARCHAR(20)	NOT NULL,
	NumeroDaOrigem					INT				NOT NULL,
	TipoOperacao					NVARCHAR(01)	NULL,	  -- ["D"(Débito) ou "C"(Crédito)]
	ValorDaOrigemProdutos			MONEY			NULL,
	ValorDaOrigemIpi				MONEY			NULL,
	ValorDaOrigemTotal				MONEY			NULL,
	PorComissao						MONEY			NULL,
	ValorComissao					MONEY			NULL,
	SaldoParcialPedido				MONEY			NULL,
	SaldoParcialComissao			MONEY			NULL,
	TituloLiquidado					NVARCHAR(01)	NULL,
	TotalLiquidado					MONEY 			NULL,
	SaldoParcialPedidoLiquidado		MONEY			NULL
	
	
) 

AS
BEGIN
	----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....
	-- Preenchecher o conteúdo da tabela temporária com as instruções abaixo:
	----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....
	DECLARE @SaldoParcial			MONEY
	DECLARE @SaldoParcialComissao	MONEY
	DECLARE @SaldoParcialLiquidado	MONEY

	-- 01.a) Pegar os dados do pedido de venda
	DECLARE @PedidoData				DATETIME
	DECLARE @PedidoTotalProdutos	MONEY
	DECLARE @PedidoTotalIPI			MONEY
	DECLARE @PedidoTotal			MONEY
	DECLARE	@PedidoPorComissao		SMALLMONEY
	DECLARE @PedidoValComissao		MONEY
	DECLARE	@PedidoCnpj				NVARCHAR(18)
	
	SET @SaldoParcial			= 0
	SET	@SaldoParcialComissao	= 0
	SET @SaldoParcialLiquidado  = 0
	
	SELECT TOP 01
		@PedidoCnpj				= CCCGC,
		@PedidoData				= LPENT,
		@PedidoTotalProdutos	= LPTGERed,
		@PedidoTotalIPI			= LPTIPRed,
		@PedidoTotal			= LPTOTPedRed,
		@PedidoPorComissao      = LpCom,
		@PedidoValComissao		= ROUND((LpCom * LPTGERed), 2 )
	FROM LPV
	WHERE LPV.LPEMP = @PedidoEmpresa
	AND   LPV.LPPED = @PedidoNumero
	-- 01.b) Gravar como Débito na tabela temporária
	IF ISNULL(@@ROWCOUNT, 0 ) > 0	
		
		SET @SaldoParcial			+= @PedidoTotal
		SET @SaldoParcialComissao	+= @PedidoValComissao
		SET @SaldoParcialLiquidado  += @PedidoTotal
		
		BEGIN
			INSERT @tExtratoPedido
				(Empresa,
				 Origem,
				 NumeroDaOrigem,
				 TipoOperacao,
				 ValorDaOrigemProdutos,
				 ValorDaOrigemIpi,
				 ValorDaOrigemTotal,
				 PorComissao,
				 ValorComissao,
				 SaldoParcialPedido,
				 SaldoParcialComissao,
				 TituloLiquidado,
				 TotalLiquidado,
				 SaldoParcialPedidoLiquidado )
			VALUES
				(@PedidoEmpresa, 
				'PV', 
				@PedidoNumero, 
				'D', 
				@PedidoTotalProdutos,
				@PedidoTotalIPI,
				@PedidoTotal,
				@PedidoPorComissao,
				@PedidoValComissao,
				@SaldoParcial,
				@SaldoParcialComissao,
				'S', 
				@PedidoTotal,
				@SaldoParcialLiquidado)
	END	-- IF ISNULL(@@ROWCOUNT, 0 ) > 0	
	
	-- 02.a) Criar um cursor com o resultado dos títulos do fluxo de caixa vinculados ao pedido
	DECLARE CURSOR_FLUXO_CAIXA_DO_PEDIDO_DE_VENDA CURSOR STATIC FOR
	SELECT 
		LFLUENP,				-- Empresa
		LFLUREG,				-- Número do Título
		CASE UPPER(LFLUPAG) 
			WHEN 'P' THEN 'D' 
			ELSE		  'C' 
		END,					-- Pagar/Receber
		LFLUSIT,				-- Tipo do Título
		LFLUDOC,				-- Documento
		LFLUDO1,				-- Parcela
		LFLUDOTOTPAR,			-- Total de Parcelas
		LFLUPED,				-- Número do Pedido de Venda
		LFLUVAL,				-- Valor Total do Título
		LFLUABE                 -- Título Liquidado
		
		
	FROM LAFLU
	WHERE LAFLU.LFLUENP = @PedidoEmpresa
	AND   LAFLU.LFLUPED = @PedidoNumero
	AND   LAFLU.CCCGC	= @PedidoCnpj
	AND	  LAFLU.LFLUELI = 'N'
	
	DECLARE @FluxoTotalBaixado		MONEY
	
	-- 02.b) Ler o cursor e verificar as consistências
	DECLARE @c_FluxoEmpresa			NVARCHAR(02),	@c_FluxoTitulo			INT,			@c_FluxoDebCred		NVARCHAR(01),
			@c_FluxoTipo			NVARCHAR(01),	@c_FluxoDocumento		DECIMAL(10,0),	@c_FluxoParcela		NVARCHAR(03),
			@c_FluxoTotalParcelas	NVARCHAR(03),	@c_FluxoPedidoNumero	INT,			@C_FluxoValor		MONEY,
			@c_FluxoTituloLiquidado NVARCHAR(01)

	OPEN			CURSOR_FLUXO_CAIXA_DO_PEDIDO_DE_VENDA
	FETCH NEXT FROM	CURSOR_FLUXO_CAIXA_DO_PEDIDO_DE_VENDA
	INTO	@c_FluxoEmpresa, 			@c_FluxoTitulo,			@c_FluxoDebCred,
			@c_FluxoTipo,				@c_FluxoDocumento,		@c_FluxoParcela,
			@c_FluxoTotalParcelas,		@c_FluxoPedidoNumero,	@C_FluxoValor,
			@c_FluxoTituloLiquidado
			
	WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0		
		BEGIN
		
			-- Pegar o Total Baixado
			SET @FluxoTotalBaixado = ISNULL((SELECT SUM(LAFLUBAI.LFluBai1Val ) FROM LAFLUBAI WHERE LAFLUBAI.LFLUREG = @c_FluxoTitulo ), 0 )

			IF @c_FluxoDebCred = 'C'
				BEGIN
					SET @SaldoParcial			-= @C_FluxoValor
					SET @SaldoParcialLiquidado	-= @FluxoTotalBaixado
				END
			ELSE
				BEGIN			
					SET @SaldoParcial			+= @C_FluxoValor	
					SET @SaldoParcialLiquidado  += @FluxoTotalBaixado
			END
			

			-- Gravar o título na tabela
			INSERT @tExtratoPedido
				(Empresa,
				 Origem,
				 NumeroDaOrigem,
				 TipoOperacao,
				 ValorDaOrigemProdutos,
				 ValorDaOrigemIpi,
				 ValorDaOrigemTotal,
				 PorComissao,
				 ValorComissao,
				 SaldoParcialPedido,
				 SaldoParcialComissao,
				 TituloLiquidado,
				 TotalLiquidado,
				 SaldoParcialPedidoLiquidado )
			VALUES
				(@c_FluxoEmpresa, 
				'FC', 
				@c_FluxoTitulo, 
				@c_FluxoDebCred, 
				@C_FluxoValor,
				0,
				@C_FluxoValor,
				0,
				0,
				@SaldoParcial,
				@SaldoParcialComissao,
				@c_FluxoTituloLiquidado,
				@FluxoTotalBaixado,
				@SaldoParcialLiquidado )			

		FETCH NEXT FROM	CURSOR_FLUXO_CAIXA_DO_PEDIDO_DE_VENDA
		INTO	@c_FluxoEmpresa, 			@c_FluxoTitulo,			@c_FluxoDebCred,
				@c_FluxoTipo,				@c_FluxoDocumento,		@c_FluxoParcela,
				@c_FluxoTotalParcelas,		@c_FluxoPedidoNumero,	@C_FluxoValor,
				@c_FluxoTituloLiquidado
		
	END -- WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0		
	
	CLOSE		CURSOR_FLUXO_CAIXA_DO_PEDIDO_DE_VENDA 
	DEALLOCATE	CURSOR_FLUXO_CAIXA_DO_PEDIDO_DE_VENDA
		
	RETURN 
END


GO
GRANT SELECT
    ON OBJECT::[dbo].[GPFN_RetornarExtratoPedidoDeVenda] TO [interclick]
    AS [dbo];

