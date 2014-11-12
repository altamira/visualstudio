-- =====================================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description:	Rotina Auximiar 01 da procedure
--				RetornarSituacaoParaOPedidoDeVenda
-- =====================================================
CREATE PROCEDURE [dbo].[GPSP_RetornarSituacaoParaOPedidoDeVendaAux01]
	-- Parâmetros da Procedure
	@Empresa				NVARCHAR(02),		-- LpEmp
	@PedidoDeVenda			INT,				-- LpPed
	@SequenciaEtapaCheck	SMALLINT,			-- LpEt2Seq
	@CodigoDaSituacaoAtual	SMALLINT	OUTPUT	-- LpEt2Seq
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @DataNulaGPIMAC	DATETIME

	SET @DataNulaGPIMAC			= CAST('1753-01-01' AS DATETIME )
	SET @CodigoDaSituacaoAtual  = 0

	SELECT TOP 01
	@CodigoDaSituacaoAtual	= LPEt2Seq
	FROM	LPVSITETAPA
	WHERE	LPEMP									= @Empresa
	AND		LPPED									= @PedidoDeVenda
	AND		LPEt2Seq								= @SequenciaEtapaCheck
	AND		NOT (ISNULL(LPEt2IniDat, '1753-01-01' ) = @DataNulaGPIMAC )
	ORDER BY LPEMP ASC, LPPED ASC, LPET2SEQ ASC
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarSituacaoParaOPedidoDeVendaAux01] TO [interclick]
    AS [dbo];

