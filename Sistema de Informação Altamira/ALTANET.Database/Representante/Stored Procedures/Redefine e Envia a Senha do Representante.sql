









CREATE PROCEDURE [Representante].[Redefine e Envia a Senha do Representante]
	@Representante				AS CHAR(3),
	@Email						AS NVARCHAR(100),
	@NovaSenha					AS NVARCHAR(40),
	@NovaSenhaCriptografada		AS NVARCHAR(40)
AS
	SET NOCOUNT ON

	DECLARE @MailTo	AS NVARCHAR(200)
	DECLARE @body	AS NVARCHAR(MAX)

	UPDATE 
		[Representante]
	SET 
		[Senha] = @NovaSenhaCriptografada,
		[Data de Validade da Senha] = GETDATE(),
		[Data da Última Alteração da Senha] = GETDATE()
	WHERE 
		CAST(LTRIM(RTRIM([Código])) AS INT) = CAST(LTRIM(RTRIM(@Representante)) AS INT) 
		AND LTRIM(RTRIM([Email])) = LTRIM(RTRIM(@Email))
		AND [Acesso Bloqueado] = 0

	IF @@ROWCOUNT > 0
	BEGIN
		DECLARE @Nome	AS NVARCHAR(50)
		
		SELECT 
			--@Representante	= [Código],
			@Nome			= [Nome]
		FROM
			[Representante]
		WHERE 
			CAST(LTRIM(RTRIM([Código])) AS INT) = CAST(LTRIM(RTRIM(@Representante)) AS INT) 
		
		SET @body = N'<HTML><HEADER><TITLE>Solicitação de Senha</TITLE></HEADER><BODY STYLE="font-family: Arial, Helvetica, Verdana, sans-serif; font-size:10pt">Segue a senha de acesso ao sistema de consulta de Orçamentos e Pedidos da Altamira:<BR><BR>' + CHAR(13) + CHAR(13) + 
					N'<TABLE STYLE="font-family: Arial, Helvetica, Verdana, sans-serif; font-size:10pt">' + CHAR(13) +
					N'<TR><TD>Endereço do site (*): </TD>' + '<TD><B><A HREF="http://vendas.altamira.com.br:8080/">http://vendas.altamira.com.br:8080</A></B></TD></TR>' + CHAR(13) + 
					N'<TR><TD>Nome do Representante: </TD>' + '<TD><B>' + LTRIM(RTRIM(@Nome)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Código de Acesso:</TD>' + '<TD><B>' + LTRIM(RTRIM(@Representante)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Nova Senha: </TD>' + '<TD><B>' + LTRIM(RTRIM(@NovaSenha)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Email: </TD>' + '<TD><B>' + LTRIM(RTRIM(@Email)) + '</TD></TR>' + CHAR(13) + 
					N'</TABLE><BR>' + CHAR(13) +
					N'<P>(*) Endereço para acesso externo via internet ou 3G. Para uso dentro da rede da Altamira via Wi-Fi <B><A HREF="http://vendas.altamira.com.br">http://vendas.altamira.com.br</A></B>.' + CHAR(13) +
					N'<P>Caso não tenha solicitado o reenvio de senha, favor entrar em contato com o Suporte Técnico.<BR><BR>' + CHAR(13) +
					N'<P>Atenciosamente,<BR><BR><BR>Suporte Técnico da Altamira<BR><mailto:sistemas.ti@altamira.com.br>sistemas.ti@altamira.com.br</A><BR>(11) 2095-2855 Ramal 2821/2890<BR>Altamira Industria Metalurgica Ltda.</P>' + CHAR(13)
						
		EXEC [msdb].dbo.sp_send_dbmail
			@profile_name = N'Sistema.Gestao',
			@recipients = @Email,
			@blind_copy_recipients = N'sistemas.ti@altamira.com.br',
			--@copy_recipients = N'sistemas.ti@altamira.com.br',
			@subject = N'Altamira - Reenvio de Senha',
			@body_format = N'HTML',
			@body =	@body
			
		SELECT 'Uma nova senha foi enviada para o email ' + @Email + '.' AS Mensagem
		
		RETURN 1
	END
	ELSE
	BEGIN
		SET @body = N'<HTML><HEADER><TITLE>Solicitação de Senha</TITLE></HEADER><BODY STYLE="font-family: Arial, Helvetica, Verdana, sans-serif; font-size:10pt">Solicitação de Senha:<BR><BR>' + CHAR(13) + CHAR(13) + 
					N'<TABLE STYLE="font-family: Arial, Helvetica, Verdana, sans-serif; font-size:10pt">' + CHAR(13) +
					N'<TR><TD>Código de Acesso:</TD>' + '<TD><B>' + LTRIM(RTRIM(@Representante)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Nova Senha: </TD>' + '<TD><B>' + LTRIM(RTRIM(@NovaSenha)) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD>Email: </TD>' + '<TD><B>' + LTRIM(RTRIM(@Email)) + '</TD></TR>' + CHAR(13) + 
					N'</TABLE><BR>' + CHAR(13) +
					N'<P>Caso não tenha solicitado o reenvio de senha, favor avisar o Suporte Técnico da Altamira.' + CHAR(13) +
					N'<P>Em caso de dúvida, favor enviar email para o Suporte Técnico da Altamira <mailto:sistemas.ti@altamira.com.br>sistemas.ti@altamira.com.br</A></P>' + CHAR(13)
						
		EXEC [msdb].dbo.sp_send_dbmail
			@profile_name = N'Sistema.Gestao',
			@recipients = N'sistemas.ti@altamira.com.br',
			--@blind_copy_recipients = N'sistemas.ti@altamira.com.br',
			--@copy_recipients = N'sistemas.ti@altamira.com.br',
			@subject = N'Tentativa de Reenvio de Senha',
			@body_format = N'HTML',
			@body =	@body
	END
	
	SELECT 'O código ou email do Representante não foi encontrado, verifique se digitou corretamente.' AS Mensagem
	
	RETURN 0
	










GO
GRANT EXECUTE
    ON OBJECT::[Representante].[Redefine e Envia a Senha do Representante] TO [altanet]
    AS [dbo];

