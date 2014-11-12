











CREATE PROCEDURE [Representante].[Seleciona Pedido de Venda]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Numero			AS INT
AS

	SET NOCOUNT ON;
	
	SELECT [Pedido de Venda].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Pedido de Venda] ON [Representante].Código = [Pedido de Venda].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND [Pedido de Venda].[Número] = @Numero
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Seleciona Pedido de Venda', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
	
	SELECT [Item do Pedido de Venda].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Pedido de Venda] ON [Representante].Código = [Pedido de Venda].[Código do Representante] INNER JOIN 
		[Item do Pedido de Venda] ON [Pedido de Venda].[Número] = [Item do Pedido de Venda].[Número do Pedido de Venda]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND [Pedido de Venda].[Número] = @Numero	

	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Seleciona Itens do Pedido de Venda', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 











GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Seleciona Pedido de Venda] TO [altanet]
    AS [dbo];

