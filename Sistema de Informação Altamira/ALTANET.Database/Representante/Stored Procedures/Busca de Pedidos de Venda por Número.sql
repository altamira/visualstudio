
















CREATE PROCEDURE [Representante].[Busca de Pedidos de Venda por Número]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Numero			AS INT
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
		AND [Pedido de Venda].[Número] = @Numero
	ORDER BY 
		[Pedido de Venda].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Pedidos de Venda por Número', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
	
END

















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Pedidos de Venda por Número] TO [altanet]
    AS [dbo];

