









CREATE PROCEDURE [Representante].[Busca de Visitas por Número]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Numero			AS INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT TOP 100 
		[Visita].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Visita] ON [Representante].Código = [Visita].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND [Número] = @Numero
	ORDER BY 
		[Visita].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Visitas por Número', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 

	
END










GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Visitas por Número] TO [altanet]
    AS [dbo];

