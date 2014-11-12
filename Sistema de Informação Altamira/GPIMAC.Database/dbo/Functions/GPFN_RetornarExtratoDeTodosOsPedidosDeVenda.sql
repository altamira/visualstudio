
-- =============================================================================================================================================
-- Author:		Denis André
-- Create date: 10/10/2012
-- Description:	Função responsável por retornar o Extrato de valores de todos os pedido de venda (Débitos) e suas baixas realizadas (créditos)
--              Pensar: Valor da Comissão
-- =============================================================================================================================================
CREATE FUNCTION [dbo].[GPFN_RetornarExtratoDeTodosOsPedidosDeVenda]
()
RETURNS 
@tExtratoPedido TABLE 
(
	-- Colunas da tabela (em memória)
	PedidoEmpresa					NVARCHAR(02)	NOT NULL,
	PedidoNumero					INT				NOT NULL,
	PedidoDtEmissao					DATETIME		NULL,
	PedidoDtEntrega					DATETIME		NULL,
	Id								INT				NOT NULL,
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
	TotalLiquidado					MONEY			NULL,
	SaldoParcialPedidoLiquidado		MONEY			NULL
	
)
AS
BEGIN
	----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....
	-- Preenchecher o conteúdo da tabela temporária com as instruções abaixo:
	----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....----....
	DECLARE 	@Id						INT,
				@Empresa				NVARCHAR(02),
				@Origem					NVARCHAR(20),
				@NumeroDaOrigem			INT,
				@TipoOperacao			NVARCHAR(01),	  -- ["D"(Débito) ou "C"(Crédito)]
				@ValorDaOrigemProdutos	MONEY,
				@ValorDaOrigemIpi		MONEY,
				@ValorDaOrigemTotal		MONEY,
				@PorComissao			MONEY,
				@ValorComissao			MONEY,
				@SaldoParcialPedido		MONEY,
				@SaldoParcialComissao	MONEY,
				@TituloLiquidado		NVARCHAR(01),
				@TotalLiquidado			MONEY,
				@SaldoParcialLiquidado	MONEY
	
	-- 01.a) Criar um cursor com o resultado dos pedidos de venda
	DECLARE	CURSOR_PEDIDO_DE_VENDA CURSOR STATIC FOR
	SELECT 
		LPEMP,
		LPPED,
		LPENT,
		Lp0SaiRed
	FROM LPV
	ORDER BY LPPED DESC
	
	-- 02.b) Ler o cursor
	DECLARE @c_PedidoEmpresa	NVARCHAR(02),
			@c_PedidoNumero		INT,
			@c_PedidoDtEmissao	DATETIME,
			@c_PedidoDtEntrega	DATETIME
	OPEN			CURSOR_PEDIDO_DE_VENDA
	FETCH NEXT FROM CURSOR_PEDIDO_DE_VENDA
	INTO	@c_PedidoEmpresa, @c_PedidoNumero, @c_PedidoDtEmissao, @c_PedidoDtEntrega
	
	WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0
		BEGIN
	
			DECLARE CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA CURSOR STATIC FOR
			SELECT
					EXTRATO_PEDIDO.Id,					EXTRATO_PEDIDO.Empresa,				EXTRATO_PEDIDO.Origem,
					EXTRATO_PEDIDO.NumeroDaOrigem,		EXTRATO_PEDIDO.TipoOperacao,		EXTRATO_PEDIDO.ValorDaOrigemProdutos,
					EXTRATO_PEDIDO.ValorDaOrigemIpi,	EXTRATO_PEDIDO.ValorDaOrigemTotal,	EXTRATO_PEDIDO.PorComissao,
					EXTRATO_PEDIDO.ValorComissao,		EXTRATO_PEDIDO.SaldoParcialPedido,	EXTRATO_PEDIDO.SaldoParcialComissao,
					EXTRATO_PEDIDO.TituloLiquidado,		EXTRATO_PEDIDO.TotalLiquidado,		EXTRATO_PEDIDO.SaldoParcialPedidoLiquidado
			FROM [dbo].[GPFN_RetornarExtratoPedidoDeVenda](@c_PedidoEmpresa, @c_PedidoNumero ) AS EXTRATO_PEDIDO
			
			OPEN			CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA
			FETCH NEXT FROM CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA
			INTO	@Id,								@Empresa,							@Origem,
					@NumeroDaOrigem,					@TipoOperacao,						@ValorDaOrigemProdutos,
					@ValorDaOrigemIpi,					@ValorDaOrigemTotal,				@PorComissao,
					@ValorComissao,						@SaldoParcialPedido,				@SaldoParcialComissao,
					@TituloLiquidado,					@TotalLiquidado,					@SaldoParcialLiquidado
					
			WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0
				BEGIN
				
					-- Gravar o extrato do pedido na tabela
					INSERT @tExtratoPedido
						(PedidoEmpresa,			PedidoNumero,				PedidoDtEmissao,				PedidoDtEntrega,
						 Id,					Empresa,					Origem,							NumeroDaOrigem,
						 TipoOperacao,			ValorDaOrigemProdutos,		ValorDaOrigemIpi,				ValorDaOrigemTotal,
						 PorComissao,			ValorComissao,				SaldoParcialPedido,				SaldoParcialComissao,
						 TituloLiquidado,		TotalLiquidado,				SaldoParcialPedidoLiquidado )
					VALUES
						(@c_PedidoEmpresa,		@c_PedidoNumero,			@c_PedidoDtEmissao,				@c_PedidoDtEntrega,
						 @Id,					@Empresa,					@Origem,						@NumeroDaOrigem, 
						 @TipoOperacao,			@ValorDaOrigemProdutos,		@ValorDaOrigemIpi,				@ValorDaOrigemTotal,
						 @PorComissao,			@ValorComissao,				@SaldoParcialPedido,			@SaldoParcialComissao,
						 @TituloLiquidado,		@TotalLiquidado,			@SaldoParcialLiquidado )						
					
				FETCH NEXT FROM CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA
				INTO	@Id,								@Empresa,							@Origem,
						@NumeroDaOrigem,					@TipoOperacao,						@ValorDaOrigemProdutos,
						@ValorDaOrigemIpi,					@ValorDaOrigemTotal,				@PorComissao,
						@ValorComissao,						@SaldoParcialPedido,				@SaldoParcialComissao,
						@TituloLiquidado,					@TotalLiquidado,					@SaldoParcialLiquidado
			END -- ISNULL(@@FETCH_STATUS, 0 ) = 0 do CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA

			CLOSE		CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA 
			DEALLOCATE	CURSOR_EXTRATO_DO_PEDIDO_DE_VENDA
	
			FETCH NEXT FROM CURSOR_PEDIDO_DE_VENDA
			INTO	@c_PedidoEmpresa, @c_PedidoNumero, @c_PedidoDtEmissao, @c_PedidoDtEntrega
			
	END -- WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0 do CURSOR_PEDIDO_DE_VENDA

	CLOSE		CURSOR_PEDIDO_DE_VENDA 
	DEALLOCATE	CURSOR_PEDIDO_DE_VENDA
		
	RETURN 
END


GO
GRANT SELECT
    ON OBJECT::[dbo].[GPFN_RetornarExtratoDeTodosOsPedidosDeVenda] TO [interclick]
    AS [dbo];

