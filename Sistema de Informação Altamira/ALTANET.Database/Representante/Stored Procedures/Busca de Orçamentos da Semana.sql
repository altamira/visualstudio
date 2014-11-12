















CREATE PROCEDURE [Representante].[Busca de Orçamentos da Semana]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		[Orçamento].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1 
		AND [Orçamento].[Data do Cadastro] >= DATEADD(WEEK, -1, GETDATE()) 
	ORDER BY 
		[Orçamento].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Orçamentos da Semana', '', @@ROWCOUNT) 
	
END
















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Orçamentos da Semana] TO [altanet]
    AS [dbo];

