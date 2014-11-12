


















CREATE PROCEDURE [Representante].[Busca de Pedidos de Venda por Período]
	@Sessao			AS UNIQUEIDENTIFIER,
	@DataInicial	AS DATE,
	@DataFinal		AS DATE
AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 1000 
		[Pedido de Venda].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Pedido de Venda] ON [Representante].Código = [Pedido de Venda].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND CAST([Pedido de Venda].[Data da Emissão] AS DATE) >= @DataInicial 
		AND CAST([Pedido de Venda].[Data da Emissão] AS DATE) <= @DataFinal
	ORDER BY 
		[Pedido de Venda].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Pedidos de Venda por Período', CAST(@DataInicial AS NVARCHAR(10)) + ' à ' + CAST(@DataFinal AS NVARCHAR(10)), @@ROWCOUNT) 
	
END



















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Pedidos de Venda por Período] TO [altanet]
    AS [dbo];

