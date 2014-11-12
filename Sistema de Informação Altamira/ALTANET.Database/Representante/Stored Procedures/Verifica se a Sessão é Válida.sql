

CREATE PROCEDURE [Representante].[Verifica se a Sessão é Válida]
	@Sessao	AS UNIQUEIDENTIFIER
AS

	DECLARE @Identificador	AS INT
	DECLARE @Validade		AS DATETIME
	
	SELECT
		@Identificador = Sessao.Identificador 
	FROM 
		[Sessão de Representante] AS Sessao
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao
		AND [Sessão Valida] = 1
		
	IF ISNULL(@Identificador, 0) > 0
	BEGIN
	
		SET @Validade = DATEADD(MINUTE, 60, GETDATE()) 
		UPDATE [Sessão de Representante] 
		SET [Data de Validade] = @Validade
		WHERE [Identificador] = @Identificador
		
		SELECT 
			@Identificador	AS [Identificador da Sessão], 
			@Sessao			AS [Identificador Único Global],
			@Validade		AS [Data de Validade]
	END
		
	


GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Verifica se a Sessão é Válida] TO [altanet]
    AS [dbo];

