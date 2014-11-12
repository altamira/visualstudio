















CREATE PROCEDURE [Representante].[Busca de Orçamentos do Dia]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		[Orçamento].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1 
		AND CAST([Orçamento].[Data do Cadastro] AS DATE) = CAST(GETDATE() AS DATE) 
	ORDER BY 
		[Orçamento].[Número] DESC
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Orçamentos do Dia', '', @@ROWCOUNT) 
	
END
















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Orçamentos do Dia] TO [altanet]
    AS [dbo];

