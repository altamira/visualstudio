













CREATE PROCEDURE [Representante].[Atualizar a Situação do Orçamento]
	@Sessao						UNIQUEIDENTIFIER,
	@Representante				INT,
	@Numero						INT,
	@Situacao					NVARCHAR(50),
	@TiposMateriais				NVARCHAR(MAX),
	@OutrosTiposMateriais		NVARCHAR(50),
	@Probabilidade				NUMERIC(3,0),
	@PrincipaisConcorrentes		NVARCHAR(MAX),
	@OutrosConcorrentes			NVARCHAR(50),
	@ProximoContato				DATE,
	@Observacao					NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SessaoID			AS INT
	DECLARE @RepresentanteID	AS INT

	SELECT 
		@SessaoID = [Sessão de Representante].Identificador,
		@RepresentanteID = [Sessão de Representante].[Identificador do Representante]
	FROM 
		[Sessão de Representante]
	WHERE 
		[Sessão de Representante].[Identificador Único Global] = @Sessao		
	
	IF (EXISTS(	SELECT * 
				FROM 
					[Informações Adicionais do Orçamento] 
				WHERE 
					[Número do Orçamento] = @Numero 
					AND [Identificador do Representante] = @RepresentanteID))
	BEGIN
		UPDATE [Informações Adicionais do Orçamento]
		SET 
			[Principais Tipos de Materiais] = @TiposMateriais,
			[Outros Tipos de Materiais] = @OutrosTiposMateriais,
			[Probabilidade de Fechamento] = @Probabilidade,
			[Nome dos Principais Concorrentes] = @PrincipaisConcorrentes,
			[Nome de Outros Concorrentes] = @OutrosConcorrentes,
			[Data do Próximo Contato] = @ProximoContato,
			[Última Situação Informada] = @Situacao
		WHERE [Número do Orçamento] = @Numero

		INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) VALUES (@Sessao, 'Altera Informações Adicionais do Orçamento', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 

	END
	ELSE
	BEGIN

		INSERT INTO [Informações Adicionais do Orçamento] 
			(
			[Identificador da Sessão],
			[Identificador do Representante],
			[Número do Orçamento], 
			[Data da Última Atualização],
			[Data do Próximo Contato],
			[Probabilidade de Fechamento],
			[Principais Tipos de Materiais],
			[Outros Tipos de Materiais],
			[Nome dos Principais Concorrêntes],
			[Nome de Outros Concorrêntes],
			[Última Situação Informada])
		VALUES 
			(
			@SessaoID,
			@RepresentanteID,
			@Numero,
			GETDATE(),
			@ProximoContato,
			@Probabilidade,
			@TiposMateriais,
			@OutrosTiposMateriais,
			@PrincipaisConcorrentes,
			@OutrosConcorrentes,
			@Situacao)

		INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) VALUES (@Sessao, 'Inclui Informações Adicionais do Orçamento', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
			
	END

	IF @@ROWCOUNT > 0
	BEGIN
		INSERT INTO [Histórico da Situação do Orçamento]
			(
			[Identificador da Sessão],
			[Identificador do Representante],
			[Número do Orçamento], 
			[Última Atualização], 
			[Situação], 
			[Observações])
		VALUES 
			(
			@SessaoID,
			@RepresentanteID,
			@Numero, 
			GETDATE(), 
			@Situacao, 
			@Observacao)
			
		INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) VALUES (@Sessao, 'Inclui Histórico do Orçamento', CAST(@Numero AS NVARCHAR(10)), @@ROWCOUNT) 
	END
	
END














GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Atualizar a Situação do Orçamento] TO [altanet]
    AS [dbo];

