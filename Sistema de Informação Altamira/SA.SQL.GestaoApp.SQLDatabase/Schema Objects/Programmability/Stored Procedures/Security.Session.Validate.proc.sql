CREATE PROCEDURE [Security].[Session.Validate]
	@Guid AS UNIQUEIDENTIFIER,
	@XmlRequest AS XML,
	@XmlResponse AS XML OUTPUT
AS
BEGIN
	
	BEGIN TRY
		IF @Guid IS NULL
		BEGIN
			DECLARE @Message XML
			SET @Message = CAST('<Message>ATENÇÃO: Tentativa de acessar o sistema com chave de sessão nula !</Message>' AS XML) 
			SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado: Sessao invalida !</Error></Message>' AS XML) 
			EXECUTE SMS.ReportError @Message
			RETURN 0
		END
		
		SET @xmlResponse = (SELECT [Security].[Session.Get](@Guid))
		
		IF @xmlResponse.exist('(/Session)[1]') = 1
		BEGIN
		
			IF (@xmlResponse.value('(/Session/ExpireDate/text())[1]', 'DATETIME') < GETDATE())
			/*BEGIN
				--DECLARE @Date VARCHAR(50) 
				--SET @Date = CONVERT(VARCHAR(50), DATEADD(mi, [Security].[SESSION_TIMEOUT](), getdate()), 20)
				
				--SET @xmlResponse.modify('replace value of (/session/expiredate/text())[1] with xs:string(sql:variable("@Date"))')

				UPDATE [Security].[Session] 
				SET [ExpireDate] = DATEADD(mi, [Security].SESSION_TIMEOUT(), GETDATE())
				WHERE [Guid] = @xmlResponse.value('(/Session/@Guid)[1]', 'UNIQUEIDENTIFIER') 
					--AND CreateBy = @xmlResponse.value('(/session/createby/text())[1]', 'INT') 
			END
			ELSE*/
			BEGIN
				--SET @xmlResponse = CAST('<Message><Error Id="1002">Acesso negado: A sessão expirou porque ficou sem atividade por mais de ' + CAST([Security].SESSION_TIMEOUT() AS NCHAR(3)) + ' minutos. Clique no botão "Liberar Acesso" e digite seu usuário e senha para reativar esta sessão.</Error></Message>' AS XML) 
				SET @xmlResponse = CAST('<Message><Error Id="1002">Acesso negado: A sessão expirou.</Error></Message>' AS XML) 
				
				RETURN 0
			END
		END
		ELSE
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="1002">Acesso negado: sessão inválida</Error></Message>' AS XML)
			
			RETURN 0
		END

	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError @xmlRequest
		SET @xmlResponse = CAST('<Message><Error Id="1005">Erro ao validar a sessão, contate o suporte técnico.</Error></Message>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 1
END












