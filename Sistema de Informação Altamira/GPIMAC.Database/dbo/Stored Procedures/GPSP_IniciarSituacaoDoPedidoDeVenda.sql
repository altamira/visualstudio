
-- =============================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description:	Esta procedure atualiza a situação
--              do pedido de venda.
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_IniciarSituacaoDoPedidoDeVenda]
	-- Add the parameters for the stored procedure here
	@Empresa			NVARCHAR(02),				-- LpEmp
	@PedidoDeVenda		INT,						-- LpPed
	@Situacao				SMALLINT,					-- LpEt2Seq
	@DataInicioExecucao	DATETIME,					-- LpEt2IniDat
	@ObservacoesEtapa	NVARCHAR(250),				-- LpEt2Obs
	@UsuarioLogado		NVARCHAR(250),				-- Usuário Logado
	@SituacaoGravada	NVARCHAR(01)	OUTPUT		-- Etapa gravada (S/N)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @LpEt2IniDat		 DATETIME
	DECLARE @Ok					 SMALLINT
	DECLARE @DataHoraInicio		 DATETIME
	DECLARE @UsuarioInicio		 NVARCHAR(20)
	DECLARE @DataNulaGPIMAC		 DATETIME
	DECLARE	@DataInicioExecucao2 DATE
	
	
    -- Insert statements for procedure here
    SET @DataNulaGPIMAC			= CAST('1753-01-01' AS DATETIME )
	SET @DataHoraInicio			= @DataNulaGPIMAC
	SET @UsuarioInicio			= ''
    SET @LpEt2IniDat			= @DataNulaGPIMAC
    SET @DataInicioExecucao2	= CAST(ISNULL(@DataInicioExecucao, '1753-01-01') AS DATE )
    
	SELECT TOP 01
		@LpEt2IniDat = ISNULL(LPEt2IniDat, '1753-01-01')
	FROM dbo.LPVSITETAPA
	WHERE LPEMP    = @Empresa
	AND   LPPED    = @PedidoDeVenda
	AND   LPEt2Seq = @Situacao
	
	SET @Ok = 0
	IF @LpEt2IniDat = @DataNulaGPIMAC
	BEGIN
		SET @Ok = 1
	END
	ELSE
	BEGIN
		IF @LpEt2IniDat > @DataInicioExecucao2
		BEGIN
			SET @Ok = 1
		END
	END
	IF @Ok = 1
	BEGIN
		IF NOT @DataInicioExecucao = @DataNulaGPIMAC
		BEGIN
			SET @DataHoraInicio = GETDATE()
			SET @UsuarioInicio  = @UsuarioLogado
		END	
		
		-- Atualizar os campos modificados
		UPDATE LPVSITETAPA SET
			LPEt2IniDat		= @DataInicioExecucao2,
			LPEt2IniUsuCri	= @UsuarioInicio,
			LPEt2IniDtHCri  = @DataHoraInicio,
			LpEt2Obs		= @ObservacoesEtapa
		WHERE LPEMP    = @Empresa
		AND   LPPED    = @PedidoDeVenda
		AND   LPEt2Seq = @Situacao
		
		IF @@ROWCOUNT > 0
			SET @SituacaoGravada = 'S'
		ELSE
			SET @SituacaoGravada = 'N'
	END
	
	-- Falta chamar a rotina que atualiza a situação atual do pedido de venda
	DECLARE @SituacaoAtual			SMALLINT
	DECLARE @SituacaoAtualDescricao	NVARCHAR(50)
	DECLARE @SituacaoAtualData		DATETIME
	DECLARE @SituacaoAtualUsuario	NVARCHAR(20)
	DECLARE @PedidoBloqueado	    NVARCHAR(01)
	DECLARE @CodigoBloqueio			SMALLINT     
	
	EXEC dbo.GPSP_RetornarSituacaoParaOPedidoDeVenda @Empresa,                  @PedidoDeVenda, 
													 @SituacaoAtual     OUTPUT, @SituacaoAtualDescricao OUTPUT, 
													 @SituacaoAtualData OUTPUT, @SituacaoAtualUsuario   OUTPUT

	SET		@PedidoBloqueado = 'N'
	SET		@CodigoBloqueio	 = 0
	
	IF @SituacaoAtual = 106 OR
	   @SituacaoAtual = 108 OR
	   @SituacaoAtual = 110 
	BEGIN
		SET @PedidoBloqueado = 'S'
		SET @CodigoBloqueio	 = @SituacaoAtual
	END
														 
	-- Atualizar a situação atual do pedido de venda e se está bloqueado ou não:
	UPDATE LPV SET
		LPEtSitRed		= @SituacaoAtualDescricao,
		LPEtSitSeqRed	= @SituacaoAtual,
		LPEtSitDatRed	= @SituacaoAtualData,
		LpEtSitUsuRed	= @SituacaoAtualUsuario,
		LpBlockRed      = @PedidoBloqueado,
		LpBlockCodRed   = @CodigoBloqueio
	WHERE	LPEMP = @Empresa
	AND		LPPED = @PedidoDeVenda

	-- Atualizar as ordens de produção vinculadas a este pedido
	UPDATE ORDFABLAN SET
		OrdPeCliBlock		= @PedidoBloqueado,
		OrdPeCliBlockCod	= @CodigoBloqueio
	WHERE OrdpecliTip = 'PV'
	AND   OrdpecliEmp = @Empresa
	AND   Ordpecli	  = @PedidoDeVenda
	
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_IniciarSituacaoDoPedidoDeVenda] TO [interclick]
    AS [dbo];

