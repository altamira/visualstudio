







CREATE PROCEDURE [Representante].[Seleciona Orçamento]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Numero			AS INT
AS

	SET NOCOUNT ON;

	SELECT [Orçamento].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND [Orçamento].[Número] = @Numero
	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Seleciona Orçamento', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
	
	SELECT * 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante] INNER JOIN 
		[Item do Orçamento] ON [Orçamento].[Número] = [Item do Orçamento].[Número do Orçamento]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND [Orçamento].[Número] = @Numero
			
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Seleciona Itens do Orçamento', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
			
	SELECT Historico.*
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante] INNER JOIN
		[Histórico da Situação do Orçamento] AS Historico ON [Orçamento].[Número] = [Historico].[Número do Orçamento]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND [Orçamento].[Número] = @Numero

	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Seleciona Histórico do Orçamento', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 







GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Seleciona Orçamento] TO [altanet]
    AS [dbo];

