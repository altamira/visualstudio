











CREATE PROCEDURE [Representante].[Busca de Orçamentos por Número]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Numero			AS INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT TOP 100 
		[Orçamento].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND [Número] = @Numero
	ORDER BY 
		[Orçamento].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Orçamentos por Número', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
	
END












GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Orçamentos por Número] TO [altanet]
    AS [dbo];

