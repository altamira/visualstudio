CREATE PROCEDURE [Sales].[Bid.CommitChanges]
	@SessionGuid UNIQUEIDENTIFIER,
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
		SET @xmlResponse = @Session --CAST('<Message><Error Id="9999">Você não tem permissão para gravar os dados do Orçamento !</Error></Message>' AS XML)
		RETURN 0
	END
	
	IF	@Session IS NULL OR
		@Session.exist('(/Session)[1]') <> 1 OR
		NOT (PATINDEX('%Bid Register%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
		LTRIM(RTRIM(@Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)'))) = '*')
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Você não tem permissão para gravar os dados do Orçamento !</Error></Message>' AS XML)
		RETURN 0
	END

	DECLARE @Client XML
	
	BEGIN TRY
		BEGIN TRANSACTION
		
		SET @Client = (SELECT T.c.query('.')
								FROM   @xmlRequest.nodes('/Register/Client') T(c)
								FOR XML PATH(''))

		EXEC @Return = Sales.[Client.CommitChanges] @SessionGuid, @Client, @XmlResponse OUTPUT
		
		IF @Return <> 1
		BEGIN
			ROLLBACK TRANSACTION
			--SET @xmlResponse = CAST('<Message><Error Id="99">Erro ao atualizar os dados do cliente.</Error></Message>' AS XML)
			RETURN 0
		END
				
		DECLARE @Id INT
		DECLARE @DateTime DATETIME
		DECLARE @ClientRegisterId INT
		DECLARE @SalesVendorId INT
		DECLARE @PurchaseTypeId INT
		DECLARE @ContactPerson XML
		DECLARE @ContactPersonCopyTo XML
		DECLARE @LocationAddress XML
		DECLARE @Comments NVARCHAR(MAX)

		SET @Id = @xmlRequest.value('(/Register/@Id)[1]', 'INT')
		SET @DateTime = GETDATE() -- @xmlRequest.value('(/Register/DateTime)[1]', 'DATETIME')
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
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">Data inválida.</Error></Message>' AS XML)
			RETURN 0
		END
			
		IF @XmlRequest.exist('(/Register/ContactPerson/Person)[1]') <> 1
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">Nenhum Contato foi escolhido.</Error></Message>' AS XML)
			RETURN 0
		END
		
		IF @XmlRequest.value('(/Register/ContactPerson/Person/Name)[1]', 'NVARCHAR(50)') IS NULL
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Nome do Contato esta em branco.</Error></Message>' AS XML)
			RETURN 0
		END

		IF  @XmlRequest.value('(/Register/ContactPerson/Person/ContactFone/Fone/AreaCode)[1]', 'NVARCHAR(50)') IS NULL OR
			@XmlRequest.value('(/Register/ContactPerson/Person/ContactFone/Fone/Prefix)[1]', 'NVARCHAR(50)') IS NULL OR
			@XmlRequest.value('(/Register/ContactPerson/Person/ContactFone/Fone/Number)[1]', 'NVARCHAR(50)') IS NULL
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Telefone de Contato esta incompleto.</Error></Message>' AS XML)
			RETURN 0
		END

		IF @XmlRequest.value('(/Register/ContactPerson/Person/ContactEmail/Email/Address)[1]', 'NVARCHAR(50)') IS NULL
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Endereço de Email esta em branco.</Error></Message>' AS XML)
			RETURN 0
		END
			
		IF @XmlRequest.exist('(/Register/LocationAddress/Address)[1]') <> 1
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">Nenhum Endereço foi escolhido.</Error></Message>' AS XML)
			RETURN 0
		END
					
		IF NOT EXISTS (SELECT * FROM Location.City WHERE Id = @XmlRequest.value('(/Register/LocationAddress/Address/City/@Id)[1]', 'INT'))
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">É obrigatório escolher uma Cidade para o Endereço selecionado.</Error></Message>' AS XML)
			RETURN 0
		END
			
		IF NOT EXISTS (SELECT * FROM Sales.Vendor WHERE Id = @XmlRequest.value('(/Register/LocationAddress/Address/Vendor/@Id)[1]', 'INT'))
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">É obrigatório escolher um Representante para o Endereço selecionado.</Error></Message>' AS XML)
			RETURN 0
		END
					
		IF NOT EXISTS(SELECT * FROM Sales.Client WHERE Id = @ClientRegisterId)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Cliente não esta cadastrado.</Error></Message>' AS XML)
			RETURN 0
		END

		IF NOT EXISTS(SELECT * FROM Sales.Vendor WHERE Id = @SalesVendorId)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 0
			SET @xmlResponse = CAST('<Message><Error Id="99">O campo Representante não foi selecionado.</Error></Message>' AS XML)
			RETURN 0
		END

		IF NOT EXISTS(SELECT * FROM Sales.PurchaseType WHERE Id = @PurchaseTypeId)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Tipo de Venda não foi selecionado.</Error></Message>' AS XML)
			RETURN 0
		END
			
		IF (@ContactPerson IS NULL)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">A Pessoa de Contato não foi selecionada !</Error></Message>' AS XML)
			RETURN 0
		END
								
		IF (@LocationAddress IS NULL)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O Endereço não foi selecionado !</Error></Message>' AS XML)
			RETURN 0
		END
								
		IF @Id = 0 OR @Id IS NULL
		BEGIN
		
			DECLARE @Numero NCHAR(10)
			DECLARE @Sequencial AS INT
			DECLARE @Num INT
			DECLARE @PrevNum INT
			--DECLARE @ClienteNovoID CHAR(14)
			
			SET @Numero = (SELECT MAX(ORCNUM) AS NUM FROM [WBCCAD].[dbo].INTEGRACAO_ORCINC)
			
			IF @Numero IS NULL
			BEGIN
				SET @Numero = (SELECT MAX([orclst_numero]) FROM [WBCCAD].[dbo].[Orclst])
			END
			
			SET @PrevNum = (SELECT MAX(ORCNUM) AS NUM FROM [WBCCAD].[dbo].INTEGRACAO_ORCINC WHERE ORCNUM <> @Numero)
			
			IF @PrevNum IS NULL
			BEGIN
				SET @PrevNum = (SELECT MAX([orclst_numero]) FROM [WBCCAD].[dbo].[Orclst] WHERE [orclst_numero] <> @Numero)
			END
			
			IF @PrevNum <> @Numero - 1
			BEGIN
				ROLLBACK TRANSACTION
				DECLARE @Message AS XML
				SET @Message=CAST(N'<Message Procedure="Sales.[Bid.CommitChanges]"><Error Id="99">A numeração dos Orçamentos esta fora da sequencia no WBCCAD, o numero anterior era ' + CAST(@PrevNum AS NVARCHAR(10)) + ', o numero atual é ' + CAST(@Numero AS NVARCHAR(10)) + '. Contate o Suporte Técnico.</Error></Message>' AS XML)
				EXECUTE SMS.ReportError @Message
				SET @xmlResponse = @Message
				RETURN 0
			END
			
			/*SET @Num = (SELECT TOP 1 si_Valor FROM [DBALTAMIRA].dbo.SI_Auxiliar WHERE LTRIM(RTRIM(si_Nome)) = 'pror_NumOrcamento')
			
			IF @Num > CAST(@Numero AS INT)
			BEGIN
				SET @Numero = REPLACE(STR(@Num, 8, 0), ' ', '0')
			END*/
			
			SET @Sequencial = CAST(SUBSTRING(@Numero, 5, 4) AS INT) + 1

			IF @Sequencial = 9999
			BEGIN
			 SET @Numero = REPLACE(STR(CAST(LEFT(@Numero, 4) AS INT) + 1, 4, 0), ' ', '0')
			 SET @Sequencial = 0
			END

			SET @Numero = LEFT(@Numero, 4) + REPLACE(STR(@Sequencial, 4, 0), ' ', '0')
		
			UPDATE [DBALTAMIRA].dbo.SI_Auxiliar SET si_Valor = CAST(@Numero AS INT) 
			WHERE LTRIM(RTRIM(si_Nome)) = 'pror_NumOrcamento'
			
			INSERT INTO Sales.Bid ([DateTime],
									Number, 
									[Sales.Client.Id], 
									[Sales.Vendor.Id],
									[Sales.PurchaseType.Id],
									ContactPerson, 
									ContactPersonCopyTo, 
									LocationAddress, 
									Comments,
									[CreateBy.Security.User.Id])
			VALUES (@DateTime, @Numero, @ClientRegisterId, @SalesVendorId, 
					@PurchaseTypeId, @ContactPerson, @ContactPersonCopyTo, 
					@LocationAddress, @Comments, 1)

			IF @@ROWCOUNT <> 1
			BEGIN
				ROLLBACK TRANSACTION
				EXECUTE SMS.ReportError
				SET @xmlResponse = CAST('<Message><Error Id="99">Os Registro de Orçamento não foi atualizado, contate o suporte técnico.</Error></Message>' AS XML)
				RETURN 0
			END
				
			SELECT @Id = SCOPE_IDENTITY()

			--SET @ClienteNovoID = @Numero
			
			--WHILE (EXISTS(SELECT * FROM [DBALTAMIRA].dbo.[VE_ClientesNovo] WHERE vecl_Codigo = @ClienteNovoID))
			--BEGIN
			--	SET @ClienteNovoID = '0' + LTRIM(RTRIM(@ClienteNovoID))
			--END
			
			--INSERT INTO [DBALTAMIRA].dbo.[VE_ClientesNovo] 
			--	(vecl_Codigo, vecl_Abreviado, vecl_Nome, vecl_Endereco, vecl_Cidade, vecl_Estado, vecl_Contato/*, vecl_Departamento*/, vecl_DDD, vecl_Telefone, vecl_Representante, vecl_Email, vecl_TipoPessoa, vecl_Transportadora)
			--SELECT TOP 1 
			--	@ClienteNovoID, 
			--	LEFT(Client.CodeName, 14), 
			--	LEFT(Client.CodeName, 50), 
			--	LEFT(Bid.LocationAddress.value('(/Address/Street)[1]', 'NVARCHAR(50)'), 50), 
			--	LEFT(Bid.LocationAddress.value('(/Address/City/Name)[1]', 'NVARCHAR(50)'), 25), 
			--	LEFT([State].Acronym, 2), 
			--	LEFT(Bid.ContactPerson.value('(/Person/Name)[1]', 'NVARCHAR(50)'), 20), 
			--	LEFT(Bid.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode)[1]', 'NVARCHAR(2)'), 2), 
			--	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix)[1]', 'NVARCHAR(4)') + '-' + Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number)[1]', 'NVARCHAR(4)'), 
			--	@xmlRequest.value('(/Register/Vendor/Code)[1]', 'CHAR(3)'), 
			--	LEFT(Bid.ContactPerson.value('(/Person/ContactEmail/Email/Address)[1]', 'NVARCHAR(50)'), 40), 
			--	'J', 2
			--FROM Sales.Bid Bid
			--	INNER JOIN Sales.Client Client ON Bid.[Sales.Client.Id] = Client.Id 
			--	LEFT JOIN Location.City city ON bid.LocationAddress.value('(/Register/LocationAddress/Address/City/@Id)[1]', 'INT') = city.Id
			--	LEFT JOIN Location.[State] [state] ON city.[Location.State.Id] = [State].Id
			--WHERE bid.Number = @Numero
			--ORDER BY Bid.[DateTime] DESC
			
			--IF @@ROWCOUNT <> 1
			--BEGIN
			--	ROLLBACK TRANSACTION
			--	EXECUTE SMS.ReportError
			--	SET @xmlResponse = CAST('<Message><Error Id="99">Houve um erro ao gravar o cadastro do cliente em VE_ClientesNovo no Gestao Antigo, o Orçamento NÃO FOI GRAVADO, deixe a tela aberta e contate o suporte técnico para identificar o problema !</Error></Message>' AS XML)
			--	RETURN 0
			--END

			INSERT INTO [DBALTAMIRA].dbo.[PRE_ORCAMENTOS] 
				(pror_Numero, 
				pror_NomeCliente, 
				pror_TipoPessoa, 
				pror_Representante, 
				pror_Endereço, 
				pror_Cidade, 
				pror_Estado, 
				pror_CEP, 
				pror_Contato, 
				pror_DDD1, 
				pror_Telefone1, 
				pror_Email1, 
				pror_Observacao, 
				pror_DataDigitação, 
				pror_DataOrcamento, 
				pror_CodSituacao, 
				pror_Situacao)
			SELECT TOP 1
				@Numero, 
				LEFT(Client.CodeName, 50), 
				'Jurídica', 
				@xmlRequest.value('(/Register/Vendor/Code)[1]', 'CHAR(3)'), 
				LEFT(Bid.LocationAddress.value('(/Address/Street)[1]', 'NVARCHAR(50)'), 50), 
				LEFT(City.Name, 30), 
				LEFT([State].Acronym, 2), 
				Bid.LocationAddress.value('(/Address/PostalCode)[1]', 'NVARCHAR(9)'), 
				LEFT(Bid.ContactPerson.value('(/Person/Name)[1]', 'NVARCHAR(50)'), 20), 
				LEFT(Bid.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode)[1]', 'NVARCHAR(2)'), 4), 
				Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix)[1]', 'NVARCHAR(4)') + '-' + Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number)[1]', 'NVARCHAR(4)'), 
				LEFT(Bid.ContactPerson.value('(/Person/ContactEmail/Email/Address)[1]', 'NVARCHAR(50)'), 40), 
				Bid.Comments, 
				GETDATE(), 
				GETDATE(), 
				1, 
				'EM ANDAMENTO'
			FROM Sales.Bid Bid
				INNER JOIN Sales.Client Client ON Bid.[Sales.Client.Id] = Client.Id 
				LEFT JOIN Location.City City ON Bid.LocationAddress.value('(/Address/City/@Id)[1]', 'INT') = City.Id
				LEFT JOIN Location.[State] [State] ON city.[Location.State.Id] = [State].Id
			WHERE Bid.Number = @Numero
			ORDER BY Bid.[DateTime] DESC
			
			IF @@ROWCOUNT <> 1
			BEGIN
				ROLLBACK TRANSACTION
				EXECUTE SMS.ReportError
				SET @xmlResponse = CAST('<Message><Error Id="99">Houve um erro ao gravar o PRE_ORCAMENTO no Gestão Antigo, o Orçamento NÃO FOI GRAVADO, deixe a tela aberta e contate o suporte técnico para identificar o problema !</Error></Message>' AS XML)
				RETURN 0
			END

			DECLARE @GPIMAC_PreClientCodigo [int]
			--SELECT * FROM dbo.[GPIMAC.CodigoSequencial]
			SET @GPIMAC_PreClientCodigo = (SELECT MAX([PreCliente.Codigo]) + 1 
											FROM dbo.[GPIMAC.CodigoSequencial]
											WHERE Id = (SELECT TOP 1 Id FROM dbo.[GPIMAC.CodigoSequencial] ORDER BY Id))
			--SELECT @GPIMAC_PreClientCodigo
			--UPDATE dbo.[GPIMAC.CodigoSequencial] SET [PreCliente.Codigo] = @GPIMAC_PreClientCodigo
			--WHERE Id = (SELECT TOP 1 Id FROM dbo.[GPIMAC.CodigoSequencial] ORDER BY Id)			

			/*INSERT INTO Gestao.dbo.GPIMAC_PreCliente 
				([Codigo]
				  ,[CNPJ]
				  ,[InscricaoEstadual]
				  ,[NomeFantasia]
				  ,[Nome]
				  ,[Endereco.TipoLogradouro.Codigo]
				  ,[Endereco.Logradouro]
				  ,[Endereco.Numero]
				  ,[Endereco.Complemento]
				  ,[Endereco.Bairro]
				  ,[Endereco.Cidade]
				  ,[Endereco.UF]
				  ,[Endereco.CodigoPostal]
				  ,[Telefone.CodigoArea]
				  ,[Telefone.Numero]
				  ,[Telefone.Ramal]
				  ,[Fax.CodigoArea]
				  ,[Fax.Numero]
				  ,[Fax.Ramal]
				  ,[Vendedor.Codigo]
				  ,[Url]
				  ,[Email]
				  ,[Indicacao]
				  ,[Observacao]
				  ,[ClientePreferencial]
				  ,[PeriodicidadeVisitas]
				  ,[Classificacao]
				  ,[Tipo])
			VALUES (@GPIMAC_PreClientCodigo, '', '', @Name, @Name
					, 'R', @Street, @AddressNumber, @Complement, @District, city.Name, [state].Acronym 
			FROM Sales.Bid bid
				INNER JOIN Sales.PurchaseType ON bid.PurchaseType = PurchaseType.Id
				--INNER JOIN Sales.Vendor vendor ON bid.VendorID = vendor.Code
				INNER JOIN Location.City city ON bid.CityID = city.Id
				INNER JOIN Location.[State] [state] ON city.StateID = [state].Id
			WHERE bid.Code = @Numero
			ORDER BY bid.[Date] DESC*/
			
			IF @@ROWCOUNT <> 1
			BEGIN
				ROLLBACK TRANSACTION
				EXECUTE SMS.ReportError
				SET @xmlResponse = CAST('<Message><Error Id="99">Houve um erro ao gravar o PreCliente no GPIMAC, o Orçamento NÃO FOI GRAVADO, deixe a tela aberta e contate o suporte técnico para identificar o problema !</Error></Message>' AS XML)
				RETURN 0
			END

			DECLARE @Vendor CHAR(20)
			SET @Vendor = @xmlRequest.value('(/Register/Vendor/Code)[1]', 'CHAR(3)')
			
			IF (@Vendor = '040' OR @Vendor = '041' OR @Vendor = '044' OR @Vendor = '052' OR @Vendor = '117')
			BEGIN
				SET @Vendor = @Vendor + ' - ADM'
			END
			
			INSERT INTO [WBCCAD].dbo.INTEGRACAO_ORCINC 
				(ORCNUM, ORCDAT, CLINOM, CLIEND, CLIFON, CLIFAX, CLIEMA, CLICON, USRCOD, ESTCOD, TIPVNDCOD, REPCOD, ACADSC, CLIMUN)
			SELECT TOP 1 
				LEFT(bid.Number, 8), 
				bid.[DateTime], 
				LEFT(Client.CodeName, 50), 
				CASE WHEN Bid.LocationAddress.value('(/Address/Street)[1]', 'NVARCHAR(50)') IS NULL THEN '' ELSE LEFT(Bid.LocationAddress.value('(/Address/Street)[1]', 'NVARCHAR(50)'), 50) END AS [Address], 
				CASE WHEN Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix)[1]', 'NVARCHAR(4)') IS NULL OR
						  Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number)[1]', 'NVARCHAR(4)') IS NULL THEN '' ELSE
				LEFT('0**' + LTRIM(RTRIM(Bid.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode)[1]', 'NVARCHAR(2)'))) + ' ' + Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix)[1]', 'NVARCHAR(4)') + '-' + Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number)[1]', 'NVARCHAR(4)'), 20) END AS Fone, '', 
				CASE WHEN Bid.ContactPerson.value('(/Person/ContactEmail/Email/Address)[1]', 'NVARCHAR(50)') IS NULL THEN '' ELSE
				LEFT(Bid.ContactPerson.value('(/Person/ContactEmail/Email/Address)[1]', 'NVARCHAR(50)'), 50) END AS [Email], 
				CASE WHEN Bid.ContactPerson.value('(/Person/Name)[1]', 'NVARCHAR(50)') IS NULL THEN '' ELSE
				LEFT(Bid.ContactPerson.value('(/Person/Name)[1]', 'NVARCHAR(50)'), 40) END AS Name, '', 
				LEFT([State].Acronym, 2), 
				LEFT(PurchaseType.[Description], 50), 
				/*LEFT(bid.VendorID, 20)*/@Vendor, '', 
				LEFT(City.Name, 50)
			FROM Sales.Bid Bid
				INNER JOIN Sales.Client Client ON Bid.[Sales.Client.Id] = Client.Id 
				INNER JOIN Sales.PurchaseType ON Bid.[Sales.PurchaseType.Id] = PurchaseType.Id
				--INNER JOIN Sales.Vendor vendor ON bid.VendorID = vendor.Code
				LEFT JOIN Location.City City ON Bid.LocationAddress.value('(/Address/City/@Id)[1]', 'INT') = city.Id
				LEFT JOIN Location.[State] [State] ON City.[Location.State.Id] = [State].Id
			WHERE bid.Number = @Numero
			ORDER BY bid.[DateTime] DESC
						
			IF @@ROWCOUNT = 1
			BEGIN
				COMMIT TRANSACTION
				SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '" Number="' + @Numero + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)
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
			UPDATE Sales.Bid SET	--[DateTime] = @DateTime, 
									[Sales.Client.Id] = @ClientRegisterId, 
									[Sales.Vendor.Id] = @SalesVendorId, 
									[Sales.PurchaseType.Id] = @PurchaseTypeId, 
									ContactPerson = @ContactPerson, 
									ContactPersonCopyTo = @ContactPersonCopyTo, 
									LocationAddress = @LocationAddress, 
									Comments = @Comments,
									[LastUpdateDate] = GETDATE()
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
		EXECUTE SMS.ReportError @xmlRequest
		SET @xmlResponse = CAST('<Message><Error Id="1005">Não foi possível gravar, contate o suporte técnico.</Error></Message>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 1
								
END












