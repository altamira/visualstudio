
-- ================================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description:	Esta procedure atualiza a situação
--              do pedido de venda por operação
-- ================================================
CREATE PROCEDURE [dbo].[GPSP_IniciarSituacaoDoPedidoDeVendaPorOperacao]
	-- Add the parameters for the stored procedure here
	@Empresa			NVARCHAR(02)	OUTPUT,		-- LpEmp
	@PedidoDeVenda		INT				OUTPUT,		-- LpPed
	@Operacao			NVARCHAR(08)	OUTPUT,
	@DataInicioExecucao	DATETIME		OUTPUT,		-- LpEt2IniDat
	@ObservacoesEtapa	NVARCHAR(250)	OUTPUT,		-- LpEt2Obs
	@UsuarioLogado		NVARCHAR(250)	OUTPUT,		-- Usuário Logado
	@SituacaoGravada	NVARCHAR(01)	OUTPUT		-- Etapa gravada (S/N)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Situacao			 SMALLINT			-- LpEt2Seq
	
    -- Insert statements for procedure here
	SET @Situacao		= 0

	IF		UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'LIBERADO'		-- LIBERADO PEDIDO
		SET @Situacao	= 05
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'OP'			-- Ordem de Serviço/Produção
		SET @Situacao	= 10
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'MP'			-- Matéria-Prima
		SET @Situacao	= 20
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'ESTAMP'		-- Estamparia
		SET @Situacao	= 30
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'PINT'			-- Pintura
		SET @Situacao	= 40
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'GALVAN'		-- Galvanização
		SET @Situacao	= 50

	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'EXPED'			-- Expedição
		SET @Situacao	= 60
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'FATURA'		-- Faturamento
		SET @Situacao	= 70
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'ENTREGA'		-- Entrega
		SET @Situacao	=  0 --80
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'CARTEIRA'		-- Carteira
		SET @Situacao	= 90
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'BANCO'			-- Banco
		SET @Situacao	= 100
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'PENDCLI'		-- Pendente Cliente 
		SET @Situacao	= 106
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'RETIDO'		-- Retido Produção
		SET @Situacao	= 108

	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'RETEXPED'		-- Retido Expedição
		SET @Situacao	= 109
		
	ELSE IF UPPER(LTRIM(RTRIM(@Operacao ) ) ) = 'CANCELAD'		-- Cancelado
		SET @Situacao	= 110

	IF @Situacao > 0
		EXEC dbo.GPSP_IniciarSituacaoDoPedidoDeVenda @Empresa,          @PedidoDeVenda, @Situacao,  @DataInicioExecucao, 
		                                             @ObservacoesEtapa, @UsuarioLogado, @SituacaoGravada OUTPUT

END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_IniciarSituacaoDoPedidoDeVendaPorOperacao] TO [interclick]
    AS [dbo];

