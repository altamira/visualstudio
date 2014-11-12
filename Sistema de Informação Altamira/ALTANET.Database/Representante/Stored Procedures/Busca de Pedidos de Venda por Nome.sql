
















CREATE PROCEDURE [Representante].[Busca de Pedidos de Venda por Nome]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Nome			AS NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	SET @Nome = LTRIM(RTRIM(@Nome))
	
	SELECT TOP 1000 
		[Pedido de Venda].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Pedido de Venda] ON [Representante].Código = [Pedido de Venda].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND ([Pedido de Venda].[Nome Fantasia] LIKE @Nome + '%' OR 
			[Pedido de Venda].[Razão Social] LIKE @Nome + '%')
	ORDER BY 
		[Pedido de Venda].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) VALUES (@Sessao, 'Busca de Pedidos de Venda por Nome', @Nome, @@ROWCOUNT) 
	
END

















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Pedidos de Venda por Nome] TO [altanet]
    AS [dbo];

