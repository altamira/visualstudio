CREATE PROCEDURE [Shipping].[PackingList.CommitChanges]
	@SessionGuid UNIQUEIDENTIFIER,
	@XmlRequest XML,
	@XmlResponse XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	SET @xmlResponse = CAST('<Message><Error Id="99">Acesso negado.</Error></Message>' AS XML)
	RETURN 0

	DECLARE @Return INT
	DECLARE @Client XML
	
	BEGIN TRY
		BEGIN TRANSACTION
		
		SET @Client = (SELECT T.c.query('.')
								FROM   @xmlRequest.nodes('/Shipping.PackingList/Client') T(c)
								FOR XML PATH(''))

		EXEC @Return = Sales.[Client.CommitChanges] @SessionGuid, @Client, @XmlResponse
		
		IF @Return <> 1
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">Erro ao atualizar os dados do cliente.</Error></Message>' AS XML)
			RETURN 0
		END
				
		DECLARE @Id INT
		DECLARE @DateTime DATETIME
		DECLARE @ClientRegisterId INT
		DECLARE @SalesVendorId INT
		DECLARE @BidPurchaseTypeId INT
		DECLARE @ContactPerson XML
		DECLARE @ContactPersonCopyTo XML
		DECLARE @LocationAddress XML
		DECLARE @Comments NVARCHAR(MAX)

		SET @Id = @xmlRequest.value('(/Shipping.PackingList/@Id)[1]', 'INT')
		SET @DateTime = @xmlRequest.value('(/Shipping.PackingList/DateTime)[1]', 'DATETIME')
		SET @ClientRegisterId = @xmlRequest.value('(/Shipping.PackingList/Client/@Id)[1]', 'INT')
		SET @SalesVendorId = @xmlRequest.value('(/Shipping.PackingList/Vendor/@Id)[1]', 'INT')
		SET @BidPurchaseTypeId = @xmlRequest.value('(/Shipping.PackingList/PurchaseType/@Id)[1]', 'INT')
		
		SET @ContactPerson =	(SELECT T.c.query('./Person')
								FROM   @xmlRequest.nodes('/Shipping.PackingList/ContactPerson') T(c)
								FOR XML PATH(''))
								
		SET @ContactPersonCopyTo =	(SELECT T.c.query('./Person')
								FROM   @xmlRequest.nodes('/Shipping.PackingList/ContactPerson') T(c)
								FOR XML PATH(''))
								
		SET @LocationAddress = 	(SELECT T.c.query('./Address')
								FROM   @xmlRequest.nodes('/Shipping.PackingList/LocationAddress') T(c)
								FOR XML PATH(''))
								
		SET @Comments = @xmlRequest.value('(/Shipping.PackingList/Comments)[1]', 'NVARCHAR(MAX)')

		IF NOT EXISTS(SELECT * FROM Sales.Client WHERE Id = @ClientRegisterId)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Cliente não esta cadastrado.</Error></Message>' AS XML)
			RETURN 0
		END

		/*IF EXISTS(SELECT * FROM Client.Register WHERE Id <> @Id AND Name = @Name)
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="99">Já existe um cliente cadastrado com este nome.</Error></Message>' AS XML)
			RETURN 0
		END*/
			
		/*IF EXISTS(SELECT * FROM Sales.Vendor WHERE Id = @SalesVendorId)
		BEGIN
			SET @xmlResponse = CAST('<Message Error Id="99">O Representante selecionado não existe no banco de dados.</Message>' AS XML)
			RETURN
		END*/
			
		/*IF NOT EXISTS(SELECT * FROM Contact.Media WHERE Id = @ContactMediaId)
		BEGIN
			SET @xmlResponse = CAST('<Message><Error Id="99">A Mídia selecionada não existe no banco de dados.</Error></Message>' AS XML)
			RETURN 0
		END*/
				
		IF @Id = 0 OR @Id IS NULL
		BEGIN
			
			/*INSERT INTO Shipping.PackingList ([DateTime], 
										[Client.Register.Id], 
										[Sales.Vendor.Id],
										[Bid.PurchaseType.Id],
										ContactPerson, 
										ContactPersonCopyTo, 
										LocationAddress, 
										Comments,
										[CreateBy.Security.User.Id],
										[LastUpdateBy.Security.User.Id])
			VALUES (@DateTime, @ClientRegisterId, @SalesVendorId, @BidPurchaseTypeId, @ContactPerson, @ContactPersonCopyTo, @LocationAddress, @Comments, 1, 1)*/
				
			SELECT @Id = SCOPE_IDENTITY()

			IF @@ROWCOUNT > 0
			BEGIN
				COMMIT TRANSACTION
				SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION
				SET @xmlResponse = CAST('<Message><Error Id="99">Os Registro de Orçamento não foi atualizado, contate o suporte técnico.</Error></Message>' AS XML)
			END

		END
		ELSE
		BEGIN
			/*UPDATE Shipping.PackingList SET	[DateTime] = @DateTime, 
										[Client.Register.Id] = @ClientRegisterId, 
										[Sales.Vendor.Id] = @SalesVendorId, 
										[Bid.PurchaseType.Id] = @BidPurchaseTypeId, 
										ContactPerson = @ContactPerson, 
										ContactPersonCopyTo = @ContactPersonCopyTo, 
										LocationAddress = @LocationAddress, 
										Comments = @Comments
			WHERE Id = @Id*/

			IF @@ROWCOUNT > 0
			BEGIN
				COMMIT TRANSACTION
				SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION
				SET @xmlResponse = CAST('<Message><Error Id="99">Os Registro de Orçamento não foi atualizado, contate o suporte técnico.</Error></Message>' AS XML)
			END
		END

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		EXECUTE SMS.ReportError
		SET @xmlResponse = CAST('<response action="' + @xmlRequest.value('(/request/@action)[1]', 'VARCHAR(max)') + '"><error id="1005"><message>Não foi possível gravar, contate o suporte técnico.</message></error></response>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 1
								
END












