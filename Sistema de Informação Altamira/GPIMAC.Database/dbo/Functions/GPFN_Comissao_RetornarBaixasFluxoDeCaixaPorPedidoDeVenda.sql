-- =================================================================================================
-- Author:		Denis André
-- Create date: 14/11/2012
-- Description:	Retornar todas as baixas do Fluxo de Caixa por Pedido de Venda
-- =================================================================================================
CREATE FUNCTION [dbo].[GPFN_Comissao_RetornarBaixasFluxoDeCaixaPorPedidoDeVenda]
(	
	-- Parâmetros de Entrada
	@PedidoEmpresa		NVARCHAR(02),
	@PedidoNumero		INT,
	@PedidoCNPJCliente	NVARCHAR(18)
)
RETURNS @t_BaixasDoFluxoDeCaixaDoPedidoDeVenda TABLE 
(
	Empresa						NVARCHAR(02)	NOT NULL,
	PedidoDeVenda				INT				NOT NULL,
	TituloFluxoDeCaixa			INT				,--NOT NULL,
	DocumentoFluxoDeCaixa		INT				,--NOT NULL,
	ParcelaFluxoDeCaixa			NVARCHAR(03)	,--NOT NULL,
	TotalParcelasFluxoDeCaixa	NVARCHAR(03)	,--NOT NULL,
	DebitoOuCredito				NVARCHAR(01)	,--NOT NULL, -- D OU C
	DtEmissaoFluxoDeCaixa		DATETIME		,--NOT NULL,
	DtVencimentoFluxoDeCaixa	DATETIME		,--NOT NULL,
	ValorParcelaFluxoDeCaixa	MONEY			,--NOT NULL,
	DtBaixaFluxoDeCaixa			DATETIME		,--NOT NULL,
	ValorBaixaFluxoDeCaixa		MONEY			--NOT NULL,
)
AS
BEGIN

	-- Variáveis para o cursor CURSOR_FLUXO_DE_CAIXA
	DECLARE
	@c_TituloFluxoDeCaixa				INT,			@c_DocumentoFluxoDeCaixa		INT,
	@c_ParcelaFluxoDeCaixa			NVARCHAR(03),		@c_TotalParcelasFluxoDeCaixa	NVARCHAR(03),
	@c_DebitoOuCredito				NVARCHAR(01),		@c_DtEmissaoFluxoDeCaixa		DATETIME,
	@c_DtVencimentoFluxoDeCaixa		DATETIME,			@c_ValorParcelaFluxoDeCaixa		MONEY,
	@c_DtBaixaFluxoDeCaixa			DATETIME,			@c_ValorBaixaFluxoDeCaixa		MONEY
	
	-- Criar um cursor que retorne todas as baixas de Fluxo de Caixa por Pedido de venda
	DECLARE	CURSOR_BAIXA_FLUXO_DE_CAIXA_POR_PEDIDO_DE_VENDA CURSOR STATIC FOR
	SELECT
		FLUXO.LFLUREG,
		FLUXO.LFLUDOC,
		FLUXO.LFLUDO1,
		FLUXO.LFLUDOTOTPAR,
		CASE FLUXO.LFLUPAG
			WHEN 'P' THEN	'C' -- Crédito (Pagar)
			ELSE			'D' -- Débito  (Receber)
		END AS DEB_CRED,	
		FLUXO.LFLUEMI,
		FLUXO.LFLUVEN,
		FLUXO.LFLUVAL,
		FLUXOBAIXA.LFluBai1Dat,
		FLUXOBAIXA.LFluBai1Val
	FROM LAFLU			FLUXO
	INNER JOIN LAFLUBAI	FLUXOBAIXA
	ON FLUXOBAIXA.LFLUREG = FLUXO.LFLUREG
	WHERE FLUXO.LFLUENP = @PedidoEmpresa
	AND   FLUXO.LFLUDOC = @PedidoNumero
	AND   FLUXO.CCCGC   = @PedidoCNPJCliente
	AND	  FLUXO.LFLUELI = 'N'

	-- ler o cursor CURSOR_PEDIDO_DE_VENDA
	OPEN  CURSOR_BAIXA_FLUXO_DE_CAIXA_POR_PEDIDO_DE_VENDA
	FETCH NEXT FROM CURSOR_BAIXA_FLUXO_DE_CAIXA_POR_PEDIDO_DE_VENDA
		INTO 	@c_TituloFluxoDeCaixa,			@c_DocumentoFluxoDeCaixa,
				@c_ParcelaFluxoDeCaixa,			@c_TotalParcelasFluxoDeCaixa,
				@c_DebitoOuCredito,				@c_DtEmissaoFluxoDeCaixa,
				@c_DtVencimentoFluxoDeCaixa,	@c_ValorParcelaFluxoDeCaixa,
				@c_DtBaixaFluxoDeCaixa,			@c_ValorBaixaFluxoDeCaixa

		WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0
		BEGIN
		
			INSERT INTO @t_BaixasDoFluxoDeCaixaDoPedidoDeVenda
			(
				Empresa,
				PedidoDeVenda,
				TituloFluxoDeCaixa,
				DocumentoFluxoDeCaixa,
				ParcelaFluxoDeCaixa,
				TotalParcelasFluxoDeCaixa,
				DebitoOuCredito,
				DtEmissaoFluxoDeCaixa,
				DtVencimentoFluxoDeCaixa,
				ValorParcelaFluxoDeCaixa,
				DtBaixaFluxoDeCaixa,
				ValorBaixaFluxoDeCaixa
			)
			VALUES
			(
				@PedidoEmpresa,					@PedidoNumero,
		 		@c_TituloFluxoDeCaixa,			@c_DocumentoFluxoDeCaixa,
				@c_ParcelaFluxoDeCaixa,			@c_TotalParcelasFluxoDeCaixa,
				@c_DebitoOuCredito,				@c_DtEmissaoFluxoDeCaixa,
				@c_DtVencimentoFluxoDeCaixa,	@c_ValorParcelaFluxoDeCaixa,
				@c_DtBaixaFluxoDeCaixa,			@c_ValorBaixaFluxoDeCaixa
			
			)			
					
		
			FETCH NEXT FROM CURSOR_BAIXA_FLUXO_DE_CAIXA_POR_PEDIDO_DE_VENDA
				INTO 	@c_TituloFluxoDeCaixa,			@c_DocumentoFluxoDeCaixa,
						@c_ParcelaFluxoDeCaixa,			@c_TotalParcelasFluxoDeCaixa,
						@c_DebitoOuCredito,				@c_DtEmissaoFluxoDeCaixa,
						@c_DtVencimentoFluxoDeCaixa,	@c_ValorParcelaFluxoDeCaixa,
						@c_DtBaixaFluxoDeCaixa,			@c_ValorBaixaFluxoDeCaixa		
		END -- WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0

		CLOSE		CURSOR_BAIXA_FLUXO_DE_CAIXA_POR_PEDIDO_DE_VENDA
		DEALLOCATE	CURSOR_BAIXA_FLUXO_DE_CAIXA_POR_PEDIDO_DE_VENDA
		
	RETURN 
END
GO
GRANT SELECT
    ON OBJECT::[dbo].[GPFN_Comissao_RetornarBaixasFluxoDeCaixaPorPedidoDeVenda] TO [interclick]
    AS [dbo];

