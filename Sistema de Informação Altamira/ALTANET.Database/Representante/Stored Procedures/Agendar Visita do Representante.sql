




















CREATE PROCEDURE [Representante].[Agendar Visita do Representante]
	@Sessao						UNIQUEIDENTIFIER,
	@Representante				INT,
	@Recado						INT,
	@DataAgenda					DATETIME,
	@NomeFantasia				NVARCHAR(20),
	@RazaoSocial				NVARCHAR(50),
	@Endereco					NVARCHAR(50),
	@Numero						NVARCHAR(5),
	@Complemento				NVARCHAR(10),
	@Bairro						NVARCHAR(30),
	@Cidade						NVARCHAR(50),
	@Estado						NCHAR(2),
	@Contato					NVARCHAR(40),
	@Departamento				NVARCHAR(35),
	@DDDTelefone				NCHAR(3),
	@Telefone					NVARCHAR(15),
	@RamalTelefone				NCHAR(5),
	@DDDCelular					NCHAR(3),
	@Celular					NVARCHAR(15),
	@Email						NVARCHAR(100),
	@Observacao					NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SessaoID			AS INT
	DECLARE @RepresentanteID	AS INT
	DECLARE @RepresentanteCODE	AS NCHAR(3)
	
	SELECT 
		@SessaoID = Identificador,
		@RepresentanteID = [Identificador do Representante],
		@RepresentanteCODE = [Código do Representante]
	FROM [Sessão de Representante]
	WHERE [Identificador Único Global] = @Sessao
	
	INSERT INTO [Visita] 
		(
		[Identificador da Sessão],
		[Identificador do Representante],
		[Identificador do Recado],
		[Código do Representante],
		[Data e Hora da Visita],
		[Nome Fantasia],
		[Razao Social],
		[Endereço],
		[Número do Endereço],
		[Complemento do Endereço],
		[Bairro],
		[Cidade],
		[Estado],
		[Nome do Contato],
		[Departamento],
		[DDD do Telefone],
		[Telefone],
		[Ramal do Telefone],
		[DDD do Celular],
		[Celular],
		[Email],
		[Observações])
	VALUES 
		(
		@SessaoID,
		@RepresentanteID,
		@Recado,
		@RepresentanteCODE,
		@DataAgenda,
		@NomeFantasia,
		@RazaoSocial,
		@Endereco,
		@Numero,
		@Complemento,
		@Bairro,
		@Cidade,
		@Estado,
		@Contato,
		@Departamento,
		@DDDTelefone,
		@Telefone,
		@RamalTelefone,
		@DDDCelular,
		@Celular,
		@Email,
		@Observacao)

	INSERT INTO [Histórico de Operações] (Sessão, Operação, Historico, [Registros Afetados]) 
	VALUES (@Sessao, 'Agendar Visita do Representante', CAST(SCOPE_IDENTITY() AS NVARCHAR(10)), @@ROWCOUNT) 


	
END





















GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Agendar Visita do Representante] TO [altanet]
    AS [dbo];

