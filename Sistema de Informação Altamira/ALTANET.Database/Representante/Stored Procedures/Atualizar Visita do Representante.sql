















CREATE PROCEDURE [Representante].[Atualizar Visita do Representante]
	@Sessao						UNIQUEIDENTIFIER,
	@Representante				INT,
	@Numero						INT,
	@DataAgenda					DATETIME,
	@Observacao					NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	IF (EXISTS(SELECT * FROM [Visita] WHERE [Número] = @Numero))
	BEGIN
		UPDATE [Visita]
		SET 
			[Data e Hora da Visita] = @DataAgenda,
			[Observações] = @Observacao
		WHERE [Número] = @Numero

		INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) VALUES (@Sessao, 'Altera Agenda', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 

	END
	ELSE
	BEGIN
		INSERT INTO [Visita] 
			([Código do Representante],
			[Data e Hora da Visita],
			Observações)
		VALUES 
			(@Representante,
			@DataAgenda,
			@Observacao)

		INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) VALUES (@Sessao, 'Inclui Agenda', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
			
	END

	
END















