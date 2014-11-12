
















CREATE PROCEDURE [Usuario].[Busca de Orçamentos da Semana]
	@Sessao AS UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (	SELECT * 
				FROM	[Usuario].[Sessão de Usuário] AS Sessao 
						INNER JOIN [Usuario].[Usuário] ON Sessao.[Identificador do Usuário] = [Usuário].Identificador 
				WHERE Sessao.[Identificador Único Global] = @Sessao AND Sessao.[Sessão Válida] = 1  )
	BEGIN
		-- Insert statements for procedure here
		SELECT TOP 1000
			[Orçamento].* 
		FROM 
			[Orçamento]
		WHERE 
			[Orçamento].[Data do Cadastro] >= DATEADD(DAY, -7, GETDATE()) 
		ORDER BY 
			[Orçamento].[Número] DESC
		
		INSERT INTO [Usuario].[Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
		VALUES (@Sessao, 'Busca de Orçamentos da Semana', '', @@ROWCOUNT) 
	END
		
END
















