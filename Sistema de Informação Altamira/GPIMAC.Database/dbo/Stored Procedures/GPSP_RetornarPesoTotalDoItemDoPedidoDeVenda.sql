-- =============================================
-- Author:		Denis André
-- Create date: 19/09/2012
-- Description:	Retornar o Peso Total do Item do
--              Pedido de venda
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_RetornarPesoTotalDoItemDoPedidoDeVenda]
	-- Add the parameters for the stored procedure here
	@Empresa			NVARCHAR(02)	OUTPUT,	-- LPEMP
	@PedidoDeVenda		INT				OUTPUT,	-- LPPED
	@ItemPedidoDeVenda	SMALLINT		OUTPUT,	-- LPSEQ
	@PesoTotal			MONEY			OUTPUT	-- Peso Total (Retorno)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SET @PesoTotal = dbo.GPFN_RetornarPesoTotalDoItemDoPedidoDeVenda(@Empresa, @PedidoDeVenda, @ItemPedidoDeVenda )
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarPesoTotalDoItemDoPedidoDeVenda] TO [interclick]
    AS [dbo];

