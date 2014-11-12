-- =============================================
-- Author:		Denis André
-- Create date: 19/09/2012
-- Description:	Retornar o Peso Total de todo o 
--              Pedido de Venda
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_RetornarPesoTotalDoDoPedidoDeVenda]
	-- Add the parameters for the stored procedure here
	@Empresa			NVARCHAR(02)	OUTPUT,	-- LPEMP
	@PedidoDeVenda		INT				OUTPUT,	-- LPPED
	@PesoTotal			MONEY			OUTPUT	-- Peso Total (Retorno)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SET @PesoTotal = dbo.GPFN_RetornarPesoTotalDoDoPedidoDeVenda(@Empresa, @PedidoDeVenda )

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarPesoTotalDoDoPedidoDeVenda] TO [interclick]
    AS [dbo];

