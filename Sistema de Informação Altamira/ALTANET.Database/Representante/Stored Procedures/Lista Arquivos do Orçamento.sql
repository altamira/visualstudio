



CREATE PROCEDURE [Representante].[Lista Arquivos do Orçamento]
	@Sessao		AS UNIQUEIDENTIFIER,
	@Orcamento	AS INT
AS

	DECLARE @SessaoID			AS INT
	DECLARE @RepresentanteID	AS INT
	
	SELECT
		@SessaoID = Sessao.[Identificador],
		@RepresentanteID = [Representante].[Identificador]
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND [Orçamento].[Número] = @Orcamento

	IF ISNULL(@RepresentanteID, 0) > 0
	BEGIN
		DECLARE @DataConsulta AS DATETIME
		
		SET @DataConsulta = GETDATE()
		
		INSERT INTO [Controle de Acesso a Arquivos] 
			([Data do Acesso],
			[Identificador da Sessão], 
			[Identificador do Representante], 
			[Número do Orçamento], 
			[Nome do Arquivo], 
			[Extensão do Arquivo], 
			[Tamanho do Arquivo], 
			[Data de Criação do Arquivo], 
			[Data da Última Alteração no Arquivo],
			[Localização do Arquivo])
		SELECT TOP 50 
			@DataConsulta,
			@SessaoID,
			@RepresentanteID,
			@Orcamento,
			[FileName],
			[Extension],
			[Length],
			[Create],
			[LastUpdate],
			[Directory]
		FROM
			GESTAOAPP.dbo.DirectoryList( 
			GESTAOAPP.Sales.[Bid.Document.Path](), 
			CASE 
				WHEN @Orcamento < 42000 THEN '31000 a 41999\' 
				WHEN @Orcamento < 53000 THEN '42000 a 52999\' 
				ELSE 
					LEFT(CAST(@Orcamento AS NVARCHAR(50)), 2) + '000 a ' +
					LEFT(CAST(@Orcamento AS NVARCHAR(50)), 2) + '999\' 
				END + CAST(@Orcamento AS NVARCHAR(50)) + '*.pdf', 
			0)
		/*UNION
		SELECT TOP 50 
			@DataConsulta,
			@SessaoID,
			@RepresentanteID,
			@Orcamento,
			[FileName],
			[Extension],
			[Length],
			[Create],
			[LastUpdate],
			[Directory]
		FROM
			GESTAOAPP.dbo.DirectoryList( 
			GESTAOAPP.Sales.[Bid.Document.Path](), 
			CASE 
				WHEN @Orcamento < 42000 THEN '31000 a 41999\' 
				WHEN @Orcamento < 53000 THEN '42000 a 52999\' 
				ELSE 
					LEFT(CAST(@Orcamento AS NVARCHAR(50)), 2) + '000 a ' +
					LEFT(CAST(@Orcamento AS NVARCHAR(50)), 2) + '999\' 
				END + CAST(@Orcamento AS NVARCHAR(50)) + '*.rtf', 
			0)	*/		
			
		INSERT INTO [Controle de Acesso a Arquivos] 
			([Data do Acesso],
			[Identificador da Sessão], 
			[Identificador do Representante], 
			[Número do Orçamento], 
			[Nome do Arquivo],
			[Extensão do Arquivo], 
			[Tamanho do Arquivo], 
			[Data de Criação do Arquivo], 
			[Data da Última Alteração no Arquivo],
			[Localização do Arquivo])
		SELECT TOP 50 
			@DataConsulta,
			@SessaoID,
			@RepresentanteID,
			@Orcamento,
			[FileName],
			[Extension],
			[Length],
			[Create],
			[LastUpdate],
			[Directory]
		FROM
			GESTAOAPP.dbo.DirectoryList( 
			GESTAOAPP.Sales.[Bid.Project.Path](), CAST(@Orcamento AS NVARCHAR(50)) + '*.pdf', 0)			
			
		SELECT DISTINCT
			[Orçamento].[Número],
			[Orçamento].[Nome Fantasia],
			[Orçamento].[Data do Cadastro]
		FROM 
			[Sessão de Representante] AS Sessao INNER JOIN
			[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
			[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante]  
		WHERE 
			Sessao.[Identificador Único Global] = @Sessao 
			AND Sessao.[Sessão Válida] = 1
			AND [Orçamento].[Número] = @Orcamento
					
		SELECT 
			[Identificador], 
			[Nome do Arquivo],
			[Nome do Arquivo com Extensão],
			[Pasta Virtual],
			[Tamanho do Arquivo], 
			[Data de Criação do Arquivo], 
			[Data da Última Alteração no Arquivo]
		FROM
			[Controle de Acesso a Arquivos] 
		WHERE 
			[Identificador da Sessão] = @SessaoID
			AND [Identificador do Representante] = @RepresentanteID
			AND [Número do Orçamento] = @Orcamento 
			AND [Data do Acesso] = @DataConsulta
	END





GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Lista Arquivos do Orçamento] TO [altanet]
    AS [dbo];

