









CREATE PROCEDURE [Representante].[Busca de Recados do Mes]
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
		AND [Recado].[Data do Cadastro] >= DATEADD(MONTH, -1, GETDATE())
	ORDER BY 
		[Recado].[Número] DESC

	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Busca de Recados do Mês', '', @@ROWCOUNT) 



END










GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Busca de Recados do Mes] TO [altanet]
    AS [dbo];

