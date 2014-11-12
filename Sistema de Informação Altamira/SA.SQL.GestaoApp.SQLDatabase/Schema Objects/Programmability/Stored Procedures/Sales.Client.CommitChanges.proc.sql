CREATE PROCEDURE [Sales].[Client.CommitChanges]
	@SessionGuId UNIQUEIDENTIFIER,
	@XmlRequest XML,
	@XmlResponse XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Return INT
	DECLARE @Session XML

	EXEC @Return = Security.[Session.Validate] @SessionGuid, NULL, @Session OUTPUT
	
	IF @Return <> 1
	BEGIN
		SET @xmlResponse = @Session --CAST('<Message><Error Id="9999">Você não tem permissão para alterar os dados do Cliente !</Error></Message>' AS XML)
		RETURN 0
	END
	
	IF	@Session IS NULL OR
		@Session.exist('(/Session)[1]') <> 1 OR
		NOT (PATINDEX('%Client Register%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
		LTRIM(RTRIM(@Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)'))) = '*')
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Você não tem permissão para alterar os dados do Cliente !</Error></Message>' AS XML)
		RETURN 0
	END
	
	DECLARE @Id INT
	DECLARE @CodeName NVARCHAR(100)
	DECLARE @ContactPerson XML
	DECLARE @LocationAddress XML
	DECLARE @SalesVendorId INT
	DECLARE @ContactMediaId INT
	
	BEGIN TRY
		SET @Id = @xmlRequest.value('(/Client/@Id)[1]', 'INT')
		SET @CodeName = @xmlRequest.value('(/Client/CodeName)[1]', 'NVARCHAR(100)')

		/*SET @ContactFone = (SELECT T.c.query('./Fone')
								FROM   @xmlRequest.nodes('/Client/ContactFone') T(c)
								FOR XML PATH(''))*/
		/*SET @ContactEmail = (SELECT T.c.query('./Email')
								FROM   @xmlRequest.nodes('/Client/ContactEmail') T(c)
								FOR XML PATH(''))*/
		SET @ContactPerson = (SELECT T.c.query('./Person')
								FROM   @xmlRequest.nodes('/Client/ContactPerson') T(c)
								FOR XML PATH(''))
		SET @LocationAddress = 	(SELECT T.c.query('./Address')
								FROM   @xmlRequest.nodes('/Client/LocationAddress') T(c)
								FOR XML PATH(''))

		SET @SalesVendorId = @xmlRequest.value('(/Client/Vendor/@Id)[1]', 'INT')
		SET @ContactMediaId = @xmlRequest.value('(/Client/Media/@Id)[1]', 'INT')

		/*IF EXISTS(SELECT * FROM Sales.Client WHERE Id <> @Id AND CodeName = @CodeName)
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="99">Já existe um cliente cadastrado com este nome.</Error></Message>' AS XML)
			RETURN 0
		END*/

		IF LEN(LTRIM(RTRIM(@CodeName))) = 0 OR @CodeName IS NULL
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="99">O Nome do Cliente não foi preenchido.</Error></Message>' AS XML)
			RETURN 0
		END
		
		IF NOT EXISTS(SELECT * FROM Sales.Vendor WHERE Id = @SalesVendorId)
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="99">O Representante selecionado não existe no banco de dados.</Error></Message>' AS XML)
			RETURN
			--SET @SalesVendorId = (SELECT TOP 1 Id FROM Sales.Vendor ORDER BY Id)
		END
			
		IF NOT EXISTS(SELECT * FROM Contact.Media WHERE Id = @ContactMediaId)
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="99">A Mídia ''' + @xmlRequest.value('(/Client/Media)[1]', 'NVARCHAR(MAX)') + ''' não existe no banco de dados.</Error></Message>' AS XML)
			RETURN 0
			--SET @ContactMediaId = (SELECT TOP 1 Id FROM Contact.Media ORDER BY Id)
		END
				
		IF @Id = 0 OR @Id IS NULL
		BEGIN
			
			INSERT INTO Sales.Client	(CodeName,
										ContactPerson, 
										LocationAddress, 
										[Sales.Vendor.Id],
										[Contact.Media.Id],
										[CreateBy.Security.User.Id])
			VALUES (@CodeName, @ContactPerson, 
					@LocationAddress, @SalesVendorId, @ContactMediaId, 1)
										
			SELECT @Id = SCOPE_IDENTITY()

			SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)

		END
		ELSE
		BEGIN
			UPDATE Sales.Client SET	CodeName = @CodeName,
									ContactPerson = @ContactPerson, 
									LocationAddress = @LocationAddress, 
									[Sales.Vendor.Id] = @SalesVendorId,
									[Contact.Media.Id] = @ContactMediaId,
									[LastUpdateDate] = GETDATE()
			WHERE Id = @Id

			SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '">Os dados foram atualizados com sucesso !</CommitChanges></Message>' AS XML)

		END
	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError @xmlRequest
		SET @xmlResponse = CAST('<Message><Error Id="1005">Não foi possível gravar, contate o suporte técnico.</Error></Message>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 1
								
END












