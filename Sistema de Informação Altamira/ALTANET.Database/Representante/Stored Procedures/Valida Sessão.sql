CREATE PROCEDURE [Representante].[Valida Sessão]
	@Sessao	AS UNIQUEIDENTIFIER
AS
	
	SELECT
		Sessao.[Data de Validade] 
	FROM 
		[Sessão de Representante] AS Sessao
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao
		AND [Sessão Valida] = 1
		
	