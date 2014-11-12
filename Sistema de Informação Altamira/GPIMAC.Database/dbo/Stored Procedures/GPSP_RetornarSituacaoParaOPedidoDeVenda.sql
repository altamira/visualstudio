
-- =============================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description:	Retornar Situação Atual do 
--				Pedido de Venda
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_RetornarSituacaoParaOPedidoDeVenda]
	-- Parâmetros da Procedure:
	@Empresa				NVARCHAR(02)	OUTPUT,	-- LpEmp
	@PedidoDeVenda			INT				OUTPUT,	-- LpPed
	@Sequencia				SMALLINT		OUTPUT,	-- LpEtSitSeq
	@Situacao				NVARCHAR(50)	OUTPUT,	-- LpEtSit
	@DataDaSituacao			DATETIME		OUTPUT, -- LpEtSitDat
	@UsuarioDaSituacao		NVARCHAR(20)	OUTPUT	-- LpEtSitUsu
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @DataNulaGPIMAC		DATETIME
	DECLARE @SequenciaCheck		SMALLINT
	DECLARE @PedidoEntregue		NVARCHAR(01)
	
	SET @DataNulaGPIMAC		= CAST('1753-01-01' AS DATETIME )	
	SET @Sequencia			= 0									-- &LpEtSitSeq = nullvalue(&LpEtSitSeq )
	SET @Situacao			= ''								-- &LpEtSit    = nullvalue(&LpEtSit    )
	SET @DataDaSituacao		= @DataNulaGPIMAC					-- &LpEtSitDat = nullvalue(&LpEtSitDat )
	SET @UsuarioDaSituacao  = ''								-- &LpEtSitUsu = nullvalue(&LpEtSitUsu )
	SET @PedidoEntregue     = 'N'

    
    -- Verificar se está cancelado:
	SET @SequenciaCheck		= 110
	EXEC dbo.GPSP_RetornarSituacaoParaOPedidoDeVendaAux01 @Empresa, @PedidoDeVenda, @SequenciaCheck, @Sequencia OUTPUT
	
	IF @Sequencia = 0
	BEGIN
		-- Verificar se está retido para a produção
		SET @SequenciaCheck		= 108
		EXEC dbo.GPSP_RetornarSituacaoParaOPedidoDeVendaAux01 @Empresa, @PedidoDeVenda, @SequenciaCheck, @Sequencia OUTPUT
	END
	
	IF @Sequencia = 0
	BEGIN
		-- Verificar se está retido para a expedicao
		SET @SequenciaCheck		= 109
		EXEC dbo.GPSP_RetornarSituacaoParaOPedidoDeVendaAux01 @Empresa, @PedidoDeVenda, @SequenciaCheck, @Sequencia OUTPUT
	END
		
	IF @Sequencia = 0
	BEGIN
		-- Verificar se está pendente cliente
		SET @SequenciaCheck		= 106
		EXEC dbo.GPSP_RetornarSituacaoParaOPedidoDeVendaAux01 @Empresa, @PedidoDeVenda, @SequenciaCheck, @Sequencia OUTPUT
	END
	
	IF @Sequencia = 0
	BEGIN
		-- Verificar se está entregue
		SELECT TOP 01
			@PedidoEntregue = LPEtEnt
		FROM LPV
		WHERE	LPEMP = @Empresa
		AND		LPPED = @PedidoDeVenda
		
		IF @PedidoEntregue = 'S'
		BEGIN
			SET @Sequencia = 80
		END
	END

	IF @Sequencia > 0
	BEGIN
		SELECT TOP 01
			@Situacao			= LTRIM(RTRIM(LPEt2Des ) ),
			@DataDaSituacao		= ISNULL(LPEt2IniDat, '1753-01-01'),
			@UsuarioDaSituacao	= LPEt2IniUsuCri
		FROM	LPVSITETAPA
		WHERE	LPEMP		= @Empresa
		AND		LPPED		= @PedidoDeVenda
		AND		LPEt2Seq	= @Sequencia
		ORDER BY LPEMP ASC, LPPED ASC, LPEt2Seq ASC
	
	END -- IF @Sequencia > 0
	ELSE
	BEGIN
		EXEC GPSP_RetornarSituacaoParaOPedidoDeVendaAux02 @Empresa, @PedidoDeVenda, @Sequencia OUTPUT, @Situacao OUTPUT, @DataDaSituacao OUTPUT, @UsuarioDaSituacao OUTPUT
	END --ELSE DO IF @Sequencia > 0

END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarSituacaoParaOPedidoDeVenda] TO [interclick]
    AS [dbo];

