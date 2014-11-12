






CREATE PROCEDURE [Representante].[Busca de Recados do Dia]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1000
		[Recado].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Recado] ON [Representante].Código = [Recado].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1 
		AND CAST([Recado].[Data do Cadastro] AS DATE) = CAST(GETDATE() AS DATE) 
	ORDER BY 
		[Recado].[Número] DESC
		
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Recados do Dia', '', @@ROWCOUNT) 	
		
END







GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Recados do Dia] TO [altanet]
    AS [dbo];

