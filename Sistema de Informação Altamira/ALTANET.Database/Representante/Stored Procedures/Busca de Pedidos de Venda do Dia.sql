












CREATE PROCEDURE [Representante].[Busca de Pedidos de Venda do Dia]
	@Sessao			AS UNIQUEIDENTIFIER
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
		AND CAST([Pedido de Venda].[Data da Emissão] AS DATE) = CAST(GETDATE() AS DATE) 
	ORDER BY 
		[Pedido de Venda].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Pedidos de Venda do Dia', '', @@ROWCOUNT) 
	
END













GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Pedidos de Venda do Dia] TO [altanet]
    AS [dbo];

