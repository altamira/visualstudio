

CREATE PROCEDURE [Representante].[Download de Arquivo do Orçamento]
	@Sessao		AS UNIQUEIDENTIFIER,
	@Arquivo	AS INT
AS

	DECLARE @SessaoID			AS INT
	DECLARE @RepresentanteID	AS INT
			
	SELECT 
		Arquivo.*
	FROM 
		[Sessão de Representante] AS Sessao INNER JOIN
		[Representante] ON Sessao.[Identificador do Representante] = Representante.Identificador INNER JOIN 
		[Orçamento] ON [Representante].Código = [Orçamento].[Código do Representante] INNER JOIN
		[Controle de Acesso a Arquivos] Arquivo ON	[Orçamento].[Número] = [Arquivo].[Número do Orçamento] 
	WHERE 
		Sessao.[Identificador Único Global] = @Sessao 
		AND Sessao.[Sessão Válida] = 1
		AND [Representante].[Identificador] = Arquivo.[Identificador do Representante]
		AND [Arquivo].[Identificador] = @Arquivo
	
	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE [Controle de Acesso a Arquivos]
		SET [Data do Último Acesso ao Arquivo] = GETDATE(),
			[Quantidade de Acessos ao Arquivo] += 1
		WHERE 
			[Controle de Acesso a Arquivos].[Identificador] = @Arquivo
	END
	ELSE
	BEGIN
		DECLARE @body	AS NVARCHAR(MAX)	
		DECLARE @Codigo AS NVARCHAR(10)
		DECLARE @Nome	AS NVARCHAR(50)
		
		
		SELECT 
			@Codigo		= [Representante].Codigo,
			@Nome		= [Representante].Nome 
		FROM 
			[Representante].[Representante] AS Representante INNER JOIN 
			[Representante].[Sessão de Representante] AS Sessao ON Representante.Identificador = Sessao.[Identificador do Representante]
		WHERE Sessao.[Identificador Único Global] = @Sessao 
		
		SET @body = N'<HTML><HEADER><TITLE>Tentativa de Acesso A Arquivo</TITLE></HEADER><BODY STYLE="font-family: Arial, Helvetica, Verdana, sans-serif; font-size:10pt">Solicitação de Senha:<BR><BR>' + CHAR(13) + CHAR(13) + 
					N'<TABLE STYLE="font-family: Arial, Helvetica, Verdana, sans-serif; font-size:10pt">' + CHAR(13) +
					N'<TR><TD>Sessão:</TD>' + '<TD><B>' + LTRIM(RTRIM(CAST(@Sessao AS NVARCHAR(40)))) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Código do Representante:</TD>' + '<TD><B>' + LTRIM(RTRIM(@Codigo)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Nome do Representante:</TD>' + '<TD><B>' + LTRIM(RTRIM(@Nome)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>ID do Arquivo:</TD>' + '<TD><B>' + CAST(@Arquivo AS NVARCHAR(10)) + '</TD></TR>' + CHAR(13) + 
					N'</TABLE><BR></BODY></HTML>' + CHAR(13)
						
		EXEC [msdb].dbo.sp_send_dbmail
			@profile_name = N'Sistema.Gestao',
			@recipients = N'sistemas.ti@altamira.com.br',
			@subject = N'Tentativa de Acesso a Arquivo',
			@body_format = N'HTML',
			@body =	@body
	END



GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Download de Arquivo do Orçamento] TO [altanet]
    AS [dbo];

