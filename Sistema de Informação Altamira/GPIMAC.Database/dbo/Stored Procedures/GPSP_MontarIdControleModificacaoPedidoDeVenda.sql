-- =============================================
-- Author:		Denis André
-- Create date: 12/09/2012
-- Description:	Montar Campo de Identificação do
--              Controle de modificação do Pedido
--              de Venda
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_MontarIdControleModificacaoPedidoDeVenda]
	-- Add the parameters for the stored procedure here
	@Empresa		NVARCHAR(02),
	@PedidoDeVenda	INT,
	@Item			SMALLINT,
	@Identificacao	NVARCHAR(250)	OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @Id NVARCHAR(250)

	SET @Id = ''
	SET @Id += '|LPV'
	SET @Id += '|'      + LTRIM(RTRIM(@Empresa ) )
	SET @Id += '|'      + SUBSTRING(CAST((10000000000 + @PedidoDeVenda ) AS CHAR(11) ), 02, 10 )
	
	IF	@Item <= 0
	BEGIN
		SET @Id += '|CABECALHO'
	END
	ELSE
	BEGIN
		SET @Id += '|ITEM|' + SUBSTRING(CAST((10000000000 + @Item ) AS CHAR(11) ), 02, 10 )
	END
	SET @Id += '|'

	SET @Identificacao = @Id
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_MontarIdControleModificacaoPedidoDeVenda] TO [interclick]
    AS [dbo];

