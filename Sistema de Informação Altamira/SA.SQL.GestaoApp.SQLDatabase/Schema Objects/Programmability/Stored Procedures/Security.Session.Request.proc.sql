CREATE PROCEDURE [Security].[Session.Request]	
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User		AS XML
	
	DECLARE @Guid		AS UNIQUEIDENTIFIER
	DECLARE @Language	AS NVARCHAR(5)
	DECLARE @ExpireDate AS DATETIME
	
	BEGIN TRY
		SET @Language = @xmlRequest.value('(User/Language)[1]', 'VARCHAR(max)')
		
		SET @User =		(SELECT [User].Id AS '@Id',
								[User].FirstName AS 'FirstName',
								[User].LastLoginDate AS 'LastLoginDate',
								[User].Rules AS 'Rules'
						FROM [Security].[User] [User]
						WHERE [User].[UserName] = LTRIM(RTRIM(@xmlRequest.value('(/User/Username)[1]', 'VARCHAR(max)')))
						AND [User].[Password] = LTRIM(RTRIM(@xmlRequest.value('(/User/Password)[1]', 'VARCHAR(max)')))
						FOR XML PATH('User'), TYPE)

		IF (NOT @User IS NULL)
		BEGIN
			UPDATE [Security].[User] SET LastLoginDate = GETDATE() WHERE Id = @User.value('(/User/@Id)[1]', 'INT')
			
			SET @Guid = NEWID()
			--SET @ExpireDate = DATEADD(mi, [Security].SESSION_TIMEOUT(), GETDATE())
			SET @ExpireDate = DATEADD(hh, 9, GETDATE())

			INSERT INTO [Security].[Session] ([Guid], [CreateBy.Security.User.Id], [ExpireDate], [Language]) 
			VALUES (@Guid, @User.value('(/User/@Id)[1]', 'INT'), @ExpireDate, @Language)
			
			SET @xmlResponse = (SELECT [Security].[Session.Get](@Guid))
								
			RETURN 1
		END
		ELSE
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="1002">Acesso negado: usuário ou senha inválido !</Error></Message>' AS XML)
			
			RETURN 0
		END
	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError @xmlRequest
		SET @xmlResponse = CAST('<Message><Error Id="1005">Não foi possível gravar, contate o suporte técnico.</Error></Message>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 0
END












