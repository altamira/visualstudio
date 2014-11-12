




--grant execute on [Representante].[Indicadores] to altanet









CREATE PROCEDURE [Representante].[Indicadores]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Representante AS NCHAR(3)

	SELECT 
		@Representante = Representante.Código
	FROM [Representante].[Sessão de Representante] AS Sessao INNER JOIN
		[Representante].[Representante] AS Representante ON Sessao.[Identificador do Representante] = Representante.Identificador
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1 

	IF @Representante IS NULL
		RETURN

	----------------------------------------------- Recados ----------------------------------------------

	SELECT ISNULL(COUNT(*), 0) AS RecadoQuantidadeSemana FROM [Recado] WHERE [Recado].[Código do Representante] = @Representante AND [Recado].[Data do Cadastro] >= DATEADD(WEEK, -1, GETDATE())

	SELECT ISNULL(COUNT(*), 0) AS RecadoQuantidadeMes FROM [Recado] WHERE [Recado].[Código do Representante] = @Representante AND [Recado].[Data do Cadastro] >= DATEADD(MONTH, -1, GETDATE())

	SELECT ISNULL(COUNT(*), 0) AS RecadoQuantidadeAno FROM [Recado] WHERE [Recado].[Código do Representante] = @Representante AND [Recado].[Data do Cadastro] >= DATEADD(YEAR, -1, GETDATE())

	------------------------------------------ Quantidade de Orcamentos ----------------------------------------------

	SELECT ISNULL(COUNT(*), 0) AS OrcamentoQuantidadeSemana FROM [Orçamento] WHERE [Orçamento].[Código do Representante] = @Representante AND [Orçamento].[Data do Cadastro] >= DATEADD(WEEK, -1, GETDATE())

	SELECT ISNULL(COUNT(*), 0) AS OrcamentoQuantidadeMes FROM [Orçamento] WHERE [Orçamento].[Código do Representante] = @Representante AND [Orçamento].[Data do Cadastro] >= DATEADD(MONTH, -1, GETDATE())

	SELECT ISNULL(COUNT(*), 0) AS OrcamentoQuantidadeAno FROM [Orçamento] WHERE [Orçamento].[Código do Representante] = @Representante AND [Orçamento].[Data do Cadastro] >= DATEADD(YEAR, -1, GETDATE())

	------------------------------------------ Valores de Orcamentos ----------------------------------------------

	SELECT CAST(ISNULL(SUM([Orçamento].Total), 0) AS MONEY) AS OrcamentoValorSemana FROM [Orçamento] WHERE [Orçamento].[Código do Representante] = @Representante AND [Orçamento].[Data do Cadastro] >= DATEADD(WEEK, -1, GETDATE())

	SELECT CAST(ISNULL(SUM([Orçamento].Total), 0) AS MONEY) AS OrcamentoValorMes FROM [Orçamento] WHERE [Orçamento].[Código do Representante] = @Representante AND [Orçamento].[Data do Cadastro] >= DATEADD(MONTH, -1, GETDATE())

	SELECT CAST(ISNULL(SUM([Orçamento].Total), 0) AS MONEY) AS OrcamentoValorAno FROM [Orçamento] WHERE [Orçamento].[Código do Representante] = @Representante AND [Orçamento].[Data do Cadastro] >= DATEADD(YEAR, -1, GETDATE())

	------------------------------------------ Quantidade de Pedidos ----------------------------------------------

	SELECT ISNULL(COUNT(*), 0) AS PedidoQuantidadeSemana FROM [Pedido de Venda] WHERE [Pedido de Venda].[Código do Representante] = @Representante AND [Pedido de Venda].[Data da Emissão] >= DATEADD(WEEK, -1, GETDATE())

	SELECT ISNULL(COUNT(*), 0) AS PedidoQuantidadeMes FROM [Pedido de Venda] WHERE [Pedido de Venda].[Código do Representante] = @Representante AND [Pedido de Venda].[Data da Emissão] >= DATEADD(MONTH, -1, GETDATE())
	
	SELECT ISNULL(COUNT(*), 0) AS PedidoQuantidadeAno FROM [Pedido de Venda] WHERE [Pedido de Venda].[Código do Representante] = @Representante AND [Pedido de Venda].[Data da Emissão] >= DATEADD(YEAR, -1, GETDATE())

	------------------------------------------ Valores de Pedidos ----------------------------------------------

	SELECT CAST(ISNULL(SUM([Pedido de Venda].[Total do Pedido]), 0) AS MONEY) AS PedidoValorSemana FROM [Pedido de Venda] WHERE [Pedido de Venda].[Código do Representante] = @Representante AND [Pedido de Venda].[Data da Emissão] >= DATEADD(WEEK, -1, GETDATE())
	
	SELECT CAST(ISNULL(SUM([Pedido de Venda].[Total do Pedido]), 0) AS MONEY) AS PedidoValorMes FROM [Pedido de Venda] WHERE [Pedido de Venda].[Código do Representante] = @Representante AND [Pedido de Venda].[Data da Emissão] >= DATEADD(MONTH, -1, GETDATE())
	
	SELECT CAST(ISNULL(SUM([Pedido de Venda].[Total do Pedido]), 0) AS MONEY) AS PedidoValorAno FROM [Pedido de Venda] WHERE [Pedido de Venda].[Código do Representante] = @Representante AND [Pedido de Venda].[Data da Emissão] >= DATEADD(YEAR, -1, GETDATE())

END















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Indicadores] TO [altanet]
    AS [dbo];

