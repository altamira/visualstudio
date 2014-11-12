












CREATE PROCEDURE [Representante].[Cria Sessão do Representante]	
	@Codigo		AS NVARCHAR(3),
	@Senha		AS NVARCHAR(40)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Representante	AS INT
	DECLARE @Nome			AS NVARCHAR(50)
	DECLARE @CodigoAcesso	AS NVARCHAR(3)
	DECLARE @SenhaAcesso	AS NVARCHAR(40)
	
	DECLARE @Identificador	AS UNIQUEIDENTIFIER
	DECLARE @DataValidade	AS DATETIME
	DECLARE @Bloqueado		AS BIT
	
	SET @Identificador = NULL
	SET @Representante = NULL
	
	SELECT 
		@Representante	= [Representante].[Identificador],
		@Nome			= [Representante].[Nome], 
		@CodigoAcesso	= [Representante].[Código],
		@SenhaAcesso	= [Representante].[Senha],
		@Bloqueado		= [Representante].[Acesso Bloqueado]
	FROM 
		[Representante]
	WHERE 
		[Código] = LTRIM(RTRIM(@Codigo))
		--AND [Senha] = LTRIM(RTRIM(@Senha))

	/*IF (@Bloqueado = 1)
	BEGIN
		SELECT 'Acesso Bloqueado, entre em contato com o suporte técnico da Altamira pelo email sistemas.ti@altamira.com.br.' AS Mensagem
		RETURN 99
	END*/
	
	IF (@Codigo = @CodigoAcesso AND @Senha = @SenhaAcesso AND @Bloqueado = 0)
	BEGIN
		UPDATE	
			[Representante] 
		SET		
			[Data do Último Acesso] = GETDATE(),
			[Número de Acessos] += 1
		WHERE	
			[Identificador] = @Representante
		
		SET @Identificador = NEWID()
		--SET @@DataExpiração = DATEADD(mi, [Security].SESSION_TIMEOUT(), GETDATE())
		SET @DataValidade = DATEADD(MINUTE, 15, GETDATE())

		INSERT INTO [Sessão de Representante] 
			([Identificador Único Global], [Identificador do Representante], [Código do Representante], [Data de Validade]) 
		VALUES (@Identificador, @Representante, @CodigoAcesso, @DataValidade)
		
		SELECT 
			@Identificador	AS [Identificador da Sessão], 
			@Representante	AS [Identificador do Representante], 
			@Nome			AS [Nome do Representante],
			@DataValidade	AS [Data de Validade]
		
		RETURN 0
	END
		
	--SELECT 'Falha no controle de Acesso. Entre em contato com o suporte técnico da Altamira.' AS Mensagem
	RETURN 1
END


















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Cria Sessão do Representante] TO [altanet]
    AS [dbo];

