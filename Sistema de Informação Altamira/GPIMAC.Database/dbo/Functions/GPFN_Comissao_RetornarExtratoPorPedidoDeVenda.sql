-- =============================================
-- Author:		Denis André
-- Create date: 08/11/2012
-- Description:	Retornar uma tabela contendo um
--              extrato para acompanhar a comis-
--              são do representante do pedido 
--              de venda
-- =============================================
CREATE FUNCTION [dbo].[GPFN_Comissao_RetornarExtratoPorPedidoDeVenda]
()
RETURNS 
@tExtratoComissaoPedidoPedido TABLE 
(
	----------------------------------------------------------------------
	--          COLUNAS CUJOS DADOS VIRÃO DO PEDIDO DE VENDA            --
	----------------------------------------------------------------------
	Empresa						NVARCHAR(02)	NOT NULL,
	PedidoDeVenda				INT				NOT NULL,
	CodigoRepresentante			NVARCHAR(05)	NOT NULL,
	NomeRepresentante			NVARCHAR(200)	NOT NULL,
	DtEmissaoPedido				DATETIME		NOT NULL,
	DtEntregaPedido				DATETIME		NOT NULL,
	TotalDosProdutos			MONEY			NOT NULL,
	TotalDoPedidoDeVenda		MONEY			NOT NULL,
	IndiceParaComissao			DECIMAL(15,10)	NOT NULL,
	PorcentagemDeComissao		SMALLMONEY		NOT NULL,
	----------------------------------------------------------------------
	--           COLUNAS CUJOS DADOS VIRÃO DO FLUXO DE CAIXA            --
	----------------------------------------------------------------------
	TituloFluxoDeCaixa			INT				,--NOT NULL,
	DocumentoFluxoDeCaixa		INT				,--NOT NULL,
	ParcelaFluxoDeCaixa			NVARCHAR(03)	,--NOT NULL,
	TotalParcelasFluxoDeCaixa	NVARCHAR(03)	,--NOT NULL,
	DebitoOuCredito				NVARCHAR(01)	,--NOT NULL, -- D OU C
	DtEmissaoFluxoDeCaixa		DATETIME		,--NOT NULL,
	DtVencimentoFluxoDeCaixa	DATETIME		,--NOT NULL,
	ValorParcelaFluxoDeCaixa	MONEY			,--NOT NULL,
	DtBaixaFluxoDeCaixa			DATETIME		,--NOT NULL,
	ValorBaixaFluxoDeCaixa		MONEY			,--NOT NULL,
	----------------------------------------------------------------------
	--          COLUNAS DO CALCULO DA COMISSAO E SALDO PARCIAL          --
	----------------------------------------------------------------------
	BasCalcComissaoFluxoDeCaixa	MONEY			,--NOT NULL,
	ValorComissaoFluxoDeCaixa	MONEY			,--NOT NULL,
	SaldoParcialComissao		MONEY			--NOT NULL
)
AS
BEGIN

	-- Variaveis para o cursor CURSOR_PEDIDO_DE_VENDA
	DECLARE
	@c_Empresa						NVARCHAR(02),		@c_PedidoDeVenda				INT,
	@c_CodigoRepresentante			NVARCHAR(05),		@c_NomeRepresentante			NVARCHAR(200),
	@c_DtEmissaoPedido				DATETIME,			@c_DtEntregaPedido				DATETIME,
	@c_TotalDosProdutos				MONEY,				@c_TotalDoPedidoDeVenda			MONEY,
	@c_IndiceParaComissao			DECIMAL(15,10),		@c_PorcentagemDeComissao		SMALLMONEY,
	@c_CNPJCliente					NVARCHAR(18)

	-- Variáveis para o cursor CURSOR_FLUXO_DE_CAIXA
	DECLARE
	@c_TituloFluxoDeCaixa				INT,			@c_DocumentoFluxoDeCaixa		INT,
	@c_ParcelaFluxoDeCaixa			NVARCHAR(03),		@c_TotalParcelasFluxoDeCaixa	NVARCHAR(03),
	@c_DebitoOuCredito				NVARCHAR(01),		@c_DtEmissaoFluxoDeCaixa		DATETIME,
	@c_DtVencimentoFluxoDeCaixa		DATETIME,			@c_ValorParcelaFluxoDeCaixa		MONEY,
	@c_DtBaixaFluxoDeCaixa			DATETIME,			@c_ValorBaixaFluxoDeCaixa		MONEY,
	@c_BasCalcComissaoFluxoDeCaixa	MONEY,				@c_ValorComissaoFluxoDeCaixa	MONEY,
	@c_SaldoParcialComissao			MONEY



	-- Criar um cursor que traga todos os pedidos de venda
	DECLARE	CURSOR_PEDIDO_DE_VENDA CURSOR STATIC FOR
	SELECT 
		PV.LPEMP,
		PV.LPPED,
		PV.CCCGC,
		PV.LPVEN,
		REP.CVNOM,
		PV.LPENT,
		PV.LP0SAIRED,
		PV.LPTGERED,
		PV.LPTOTPEDRED,
		dbo.GPFN_Comissao_RetornarIndiceDoPedidoDeVenda(PV.LPEMP, PV.LPPED ) as LPIndicePedido,
		PV.LPCom
	FROM dbo.LPV			PV
	INNER JOIN dbo.CAREP	REP
	ON	PV.LPVEN = REP.CVCOD

	-- ler o cursor CURSOR_PEDIDO_DE_VENDA
	OPEN  CURSOR_PEDIDO_DE_VENDA
	
		FETCH NEXT FROM CURSOR_PEDIDO_DE_VENDA
		INTO	@c_Empresa,				@c_PedidoDeVenda,			@c_CNPJCliente, 
				@c_CodigoRepresentante,	@c_NomeRepresentante,	    @c_DtEmissaoPedido,
				@c_DtEntregaPedido,		@c_TotalDosProdutos,		@c_TotalDoPedidoDeVenda,
				@c_IndiceParaComissao,	@c_PorcentagemDeComissao
				
		WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0
		BEGIN
		
			---------------------------------------------------------------------------------------------- 
			--   CHAMAR FUNCAO QUE RETORNE UM CURSOR CONTENDO AS BAIXAS DOS TITULOS DO FLUXO DE CAIXA   --
			---------------------------------------------------------------------------------------------- 
			
			
			---------------------------------------------------------------------------------------------- 


			-- Gravar os dados na tabela temporária:
			INSERT @tExtratoComissaoPedidoPedido
			(
				--------------------------------------------------------------------------------------------
				--                       COLUNAS CUJOS DADOS VÊM DO PEDIDO DE VENDA                       --
				--------------------------------------------------------------------------------------------
				Empresa,						PedidoDeVenda,					CodigoRepresentante,
				NomeRepresentante,				DtEmissaoPedido,				DtEntregaPedido,
				TotalDosProdutos,				TotalDoPedidoDeVenda,			IndiceParaComissao,
				PorcentagemDeComissao,
				--------------------------------------------------------------------------------------------
				--                        COLUNAS CUJOS DADOS VÊM DO FLUXO DE CAIXA                       --
				--------------------------------------------------------------------------------------------
				TituloFluxoDeCaixa,				DocumentoFluxoDeCaixa,			ParcelaFluxoDeCaixa,
				TotalParcelasFluxoDeCaixa,		DebitoOuCredito,				DtEmissaoFluxoDeCaixa,
				DtVencimentoFluxoDeCaixa,		ValorParcelaFluxoDeCaixa,		DtBaixaFluxoDeCaixa,
				ValorBaixaFluxoDeCaixa,
				--------------------------------------------------------------------------------------------
				--                      COLUNAS DO CALCULO DA COMISSAO E SALDO PARCIAL                    --
				--------------------------------------------------------------------------------------------
				BasCalcComissaoFluxoDeCaixa,	ValorComissaoFluxoDeCaixa,		SaldoParcialComissao
			)
			VALUES
			(
				--------------------------------------------------------------------------------------------
				--                       COLUNAS CUJOS DADOS VÊM DO PEDIDO DE VENDA                       --
				--------------------------------------------------------------------------------------------
				@c_Empresa,						@c_PedidoDeVenda,				@c_CodigoRepresentante,
				@c_NomeRepresentante,			@c_DtEmissaoPedido,				@c_DtEntregaPedido,
				@c_TotalDosProdutos,			@c_TotalDoPedidoDeVenda,		@c_IndiceParaComissao,
				@c_PorcentagemDeComissao,
				--------------------------------------------------------------------------------------------
				--                        COLUNAS CUJOS DADOS VÊM DO FLUXO DE CAIXA                       --
				--------------------------------------------------------------------------------------------
				@c_TituloFluxoDeCaixa,			@c_DocumentoFluxoDeCaixa,		@c_ParcelaFluxoDeCaixa,
				@c_TotalParcelasFluxoDeCaixa,	@c_DebitoOuCredito,				@c_DtEmissaoFluxoDeCaixa,
				@c_DtVencimentoFluxoDeCaixa,	@c_ValorParcelaFluxoDeCaixa,	@c_DtBaixaFluxoDeCaixa,
				@c_ValorBaixaFluxoDeCaixa,
				--------------------------------------------------------------------------------------------
				--                      COLUNAS DO CALCULO DA COMISSAO E SALDO PARCIAL                    --
				--------------------------------------------------------------------------------------------
				@c_BasCalcComissaoFluxoDeCaixa,	@c_ValorComissaoFluxoDeCaixa,	@c_SaldoParcialComissao			
			)


			FETCH NEXT FROM CURSOR_PEDIDO_DE_VENDA
			INTO	@c_Empresa,				@c_PedidoDeVenda,			@c_CodigoRepresentante,	
					@c_NomeRepresentante,	@c_DtEmissaoPedido,			@c_DtEntregaPedido,
					@c_TotalDosProdutos,	@c_TotalDoPedidoDeVenda,	@c_IndiceParaComissao,
					@c_PorcentagemDeComissao
		
		END -- WHILE ISNULL(@@FETCH_STATUS, 0 ) = 0
		
	
	CLOSE		CURSOR_PEDIDO_DE_VENDA
	DEALLOCATE	CURSOR_PEDIDO_DE_VENDA
	
	RETURN
END
GO
GRANT SELECT
    ON OBJECT::[dbo].[GPFN_Comissao_RetornarExtratoPorPedidoDeVenda] TO [interclick]
    AS [dbo];

