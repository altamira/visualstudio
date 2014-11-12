








CREATE PROCEDURE [Representante].[Busca de Recados por Nome]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Nome			AS NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	SET @Nome = LTRIM(RTRIM(@Nome))
	
	SELECT TOP 1000 
		[Recado].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Recado] ON [Representante].Código = [Recado].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND ([Nome Fantasia] LIKE @Nome + '%' OR [Razão Social] LIKE @Nome + '%')
	ORDER BY 
		[Recado].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Recados por Nome', @Nome, @@ROWCOUNT) 

END









GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Recados por Nome] TO [altanet]
    AS [dbo];

