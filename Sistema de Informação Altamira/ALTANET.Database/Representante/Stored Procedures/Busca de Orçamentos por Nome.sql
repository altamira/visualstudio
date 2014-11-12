











CREATE PROCEDURE [Representante].[Busca de Orçamentos por Nome]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Nome			AS NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	SET @Nome = LTRIM(RTRIM(@Nome))
	
	SELECT TOP 1000 
		[Orçamento].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND ([Nome Fantasia] LIKE @Nome + '%' OR [Razão Social] LIKE @Nome + '%')
	ORDER BY 
		[Orçamento].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Orçamentos por Nome', @Nome, @@ROWCOUNT) 
	
END












GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Orçamentos por Nome] TO [altanet]
    AS [dbo];

