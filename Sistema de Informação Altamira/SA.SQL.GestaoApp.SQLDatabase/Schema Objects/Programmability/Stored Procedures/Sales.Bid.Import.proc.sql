CREATE PROCEDURE [Sales].[Bid.Import]
	@SessionGuid UNIQUEIDENTIFIER,
	@XmlRequest XML,
	@XmlResponse XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	-- Check if a valId session

	DECLARE @Return INT
	DECLARE @Client XML
	
	BEGIN TRY
		BEGIN TRANSACTION
		
		/*SET @Client = (SELECT T.c.query('.')
								FROM   @xmlRequest.nodes('/Register/Client') T(c)
								FOR XML PATH(''))

		EXEC @Return = Sales.[Client.CommitChanges] @SessionGuid, @Client, @XmlResponse OUTPUT
		
		IF @Return <> 1
		BEGIN
			ROLLBACK TRANSACTION
			--SET @xmlResponse = CAST('<Message><Error Id="99">Erro ao atualizar os dados do cliente.</Error></Message>' AS XML)
			RETURN 0
		END*/
				
		DECLARE @Id INT
		DECLARE @DateTime DATETIME
		DECLARE @Number NCHAR(10)
		DECLARE @ClientRegisterId INT
		DECLARE @SalesVendorId INT
		DECLARE @PurchaseTypeId INT
		DECLARE @ContactPerson XML
		DECLARE @ContactPersonCopyTo XML
		DECLARE @LocationAddress XML
		DECLARE @Comments NVARCHAR(MAX)

		SET @Id = @xmlRequest.value('(/Register/@Id)[1]', 'INT')
		SET @Number = @xmlRequest.value('(/Register/Number)[1]', 'NCHAR(10)')
		SET @DateTime = @xmlRequest.value('(/Register/DateTime)[1]', 'DATETIME')
		SET @ClientRegisterId = @xmlRequest.value('(/Register/Client/@Id)[1]', 'INT')
		SET @SalesVendorId = @xmlRequest.value('(/Register/Vendor/@Id)[1]', 'INT')
		SET @PurchaseTypeId = @xmlRequest.value('(/Register/PurchaseType/@Id)[1]', 'INT')
		
		SET @ContactPerson =	(SELECT T.c.query('./Person')
								FROM   @xmlRequest.nodes('/Register/ContactPerson') T(c)
								FOR XML PATH(''))
								
		SET @ContactPersonCopyTo =	(SELECT T.c.query('./Person')
								FROM   @xmlRequest.nodes('/Register/ContactPersonCopyTo') T(c)
								FOR XML PATH(''))
								
		SET @LocationAddress = 	(SELECT T.c.query('./Address')
								FROM   @xmlRequest.nodes('/Register/LocationAddress') T(c)
								FOR XML PATH(''))
								
		SET @Comments = @xmlRequest.value('(/Register/Comments)[1]', 'NVARCHAR(MAX)')

		IF (@DateTime IS NULL)
		BEGIN
			--ROLLBACK TRANSACTION
			--SET @xmlResponse = CAST('<Message><Error Id="99">Data inválida.</Error></Message>' AS XML)
			--RETURN 0
			SET @DateTime = CAST('1990-01-01' AS DATETIME)
		END

		IF NOT EXISTS(SELECT * FROM Sales.Client WHERE Id = @ClientRegisterId)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Cliente não esta cadastrado.</Error></Message>' AS XML)
			RETURN 0
		END

		IF NOT EXISTS(SELECT * FROM Sales.Vendor WHERE Id = @SalesVendorId)
		BEGIN
			--SET @xmlResponse = CAST('<Message Error Id="99">O Representante selecionado não existe no banco de dados.</Message>' AS XML)
			--RETURN
			SET @SalesVendorId = (SELECT TOP 1 Id FROM Sales.Vendor ORDER BY Id)
		END

		IF NOT EXISTS(SELECT * FROM Sales.PurchaseType WHERE Id = @PurchaseTypeId)
		BEGIN
			--SET @xmlResponse = CAST('<Message Error Id="99">O Tipo de Venda selecionado não existe no banco de dados.</Message>' AS XML)
			--RETURN
			SET @PurchaseTypeId = (SELECT TOP 1 Id FROM Sales.PurchaseType WHERE Id = 2)
		END
						
		IF @Id = 0 OR @Id IS NULL
		BEGIN
			
			INSERT INTO Sales.Bid ([DateTime],
										Number, 
										[Sales.Client.Id], 
										[Sales.Vendor.Id],
										[Sales.PurchaseType.Id],
										ContactPerson, 
										ContactPersonCopyTo, 
										LocationAddress, 
										Comments,
										[CreateBy.Security.User.Id],
										[LastUpdateBy.Security.User.Id])
			VALUES (@DateTime, @Number, @ClientRegisterId, @SalesVendorId, 
					@PurchaseTypeId, @ContactPerson, @ContactPersonCopyTo, 
					@LocationAddress, @Comments, 1, 1)
						
			IF @@ROWCOUNT = 1
			BEGIN
				COMMIT TRANSACTION
				SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '" Number="' + @Number + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION
				EXECUTE SMS.ReportError
				SET @xmlResponse = CAST('<Message><Error Id="99">Houve um erro ao gravar os dados no WBCCAD, deixe a tela aberta e contate o suporte técnico para identificar o problema !</Error></Message>' AS XML)
				RETURN 0
			END
			
		END
		ELSE
		BEGIN
			UPDATE Sales.Bid SET	[DateTime] = @DateTime, 
									[Sales.Client.Id] = @ClientRegisterId, 
									[Sales.Vendor.Id] = @SalesVendorId, 
									[Sales.PurchaseType.Id] = @PurchaseTypeId, 
									ContactPerson = @ContactPerson, 
									ContactPersonCopyTo = @ContactPersonCopyTo, 
									LocationAddress = @LocationAddress, 
									Comments = @Comments
			WHERE Id = @Id

			IF @@ROWCOUNT = 1
			BEGIN
				COMMIT TRANSACTION
				SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION
				EXECUTE SMS.ReportError
				SET @xmlResponse = CAST('<Message><Error Id="99">Os Registro de Orçamento não foi atualizado, contate o suporte técnico.</Error></Message>' AS XML)
			END
		END

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		EXECUTE SMS.ReportError
		SET @xmlResponse = CAST('<Message><Error Id="1005">Não foi possível gravar, contate o suporte técnico.</Error></Message>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 1
								
END












