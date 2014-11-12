












CREATE PROCEDURE [Representante].[Seleciona Recado]
	@Sessao			AS UNIQUEIDENTIFIER,
	@Numero			AS INT
AS

	SET NOCOUNT ON;

	SELECT [Recado].* 
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Recado] ON [Representante].Código = [Recado].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1
		AND [Recado].[Número] = @Numero

	
	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Seleciona Recado', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 




GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Seleciona Recado] TO [altanet]
    AS [dbo];

