











CREATE PROCEDURE [Representante].[Busca de Visitas da Semana]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1000
		[Visita].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Visita] ON [Representante].Código = [Visita].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1 
		AND DATEPART(WEEK, [Visita].[Data e Hora da Visita]) = DATEPART(WEEK, GETDATE()) 
	ORDER BY 
		[Visita].[Número] DESC

	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Visitas da Semana', '', @@ROWCOUNT) 	
END












GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Visitas da Semana] TO [altanet]
    AS [dbo];

