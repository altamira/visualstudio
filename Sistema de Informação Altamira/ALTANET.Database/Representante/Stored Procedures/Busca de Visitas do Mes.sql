











CREATE PROCEDURE [Representante].[Busca de Visitas do Mes]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1000
		[Visita].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Visita] ON [Representante].Código = [Visita].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1  
		AND DATEPART(MONTH, [Visita].[Data e Hora da Visita]) = DATEPART(MONTH, GETDATE())
	ORDER BY 
		[Visita].[Número] DESC

	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Visitas do Mês', '', @@ROWCOUNT) 



END












GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Visitas do Mes] TO [altanet]
    AS [dbo];

