CREATE PROCEDURE [Attendance].[Register.CommitChanges]
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
		SET @xmlResponse = @Session --CAST('<Message><Error Id="9999">Você não tem permissão para gravar os dados do Atendimento !</Error></Message>' AS XML)
		RETURN 0
	END
	
	IF	@Session IS NULL OR
		@Session.exist('(/Session)[1]') <> 1 OR
		NOT (PATINDEX('%Attendance Register%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
		LTRIM(RTRIM(@Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)'))) = '*')
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Você não tem permissão para gravar os dados do Atendimento !</Error></Message>' AS XML)
		RETURN 0
	END
	
	DECLARE @mailTo AS NVARCHAR(MAX)
	DECLARE @Mobile AS NVARCHAR(14)
	DECLARE @body AS NVARCHAR(MAX)

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
		DECLARE @AttendanceTypeId INT
		DECLARE @AttendanceStatusId INT
		DECLARE @ContactPerson XML
		DECLARE @LocationAddress XML
		DECLARE @Products XML	
		DECLARE @Comments NVARCHAR(MAX)

		SET @Id = @xmlRequest.value('(/Register/@Id)[1]', 'INT')
		SET @DateTime = GETDATE() -- @xmlRequest.value('(/Register/DateTime)[1]', 'DATETIME')
		SET @ClientRegisterId = @xmlRequest.value('(/Register/Client/@Id)[1]', 'INT')
		SET @SalesVendorId = @xmlRequest.value('(/Register/Vendor/@Id)[1]', 'INT')
		SET @AttendanceTypeId = @xmlRequest.value('(/Register/Type/@Id)[1]', 'INT')
		SET @AttendanceStatusId = @xmlRequest.value('(/Register/Status/@Id)[1]', 'INT')
		
		SET @ContactPerson =	(SELECT T.c.query('./Person')
								FROM   @xmlRequest.nodes('/Register/ContactPerson') T(c)
								FOR XML PATH(''))
								
		SET @LocationAddress = 	(SELECT T.c.query('./Address')
								FROM   @xmlRequest.nodes('/Register/LocationAddress') T(c)
								FOR XML PATH(''))
								
		SET @Products = 		(SELECT T.c.query('./Product')
								FROM   @xmlRequest.nodes('/Register/Products') T(c)
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

		IF @XmlRequest.exist('(/Register/LocationAddress/Address)[1]') <> 1
		BEGIN
					
			IF NOT EXISTS (SELECT * FROM Location.City WHERE Id = @XmlRequest.value('(/Register/LocationAddress/Address/City/@Id)[1]', 'INT'))
			BEGIN
				ROLLBACK TRANSACTION
				SET @xmlResponse = CAST('<Message><Error Id="99">A Cidade não esta cadastrada.</Error></Message>' AS XML)
				RETURN 0
			END
			
			IF NOT EXISTS (SELECT * FROM Sales.Vendor WHERE Id = @XmlRequest.value('(/Register/LocationAddress/Address/Vendor/@Id)[1]', 'INT'))
			BEGIN
				ROLLBACK TRANSACTION
				SET @xmlResponse = CAST('<Message><Error Id="99">É obrigatório escolher um Representante para o Endereço selecionado.</Error></Message>' AS XML)
				RETURN 0
			END
			
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
			SET @xmlResponse = CAST('<Message><Error Id="99">O campo Representante não foi selecionado.</Error></Message>' AS XML)
			RETURN 0
			--SET @SalesVendorId = (SELECT TOP 1 Id FROM Sales.Vendor ORDER BY Id)
		END
			
		IF NOT EXISTS(SELECT * FROM Attendance.[Type] WHERE Id = @AttendanceTypeId)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O campo Tipo de Atendimento não foi selecionado.</Error></Message>' AS XML)
			RETURN 0
			--SET @AttendanceTypeId = (SELECT TOP 1 Id FROM Attendance.[Type] ORDER BY Id)
		END
			
		IF NOT EXISTS(SELECT * FROM Attendance.[Status] WHERE Id = @AttendanceStatusId)
		BEGIN
			ROLLBACK TRANSACTION
			SET @xmlResponse = CAST('<Message><Error Id="99">O campo Situação do Atendimento não foi selecionado.</Error></Message>' AS XML)
			RETURN 0
			--SET @AttendanceStatusId = (SELECT TOP 1 Id FROM Attendance.[Status] ORDER BY Id)
		END
				
		IF @Id = 0 OR @Id IS NULL
		BEGIN
			
			INSERT INTO Attendance.Register ([DateTime], 
									[Sales.Client.Id], 
									[Sales.Vendor.Id],
									[Attendance.Type.Id],
									[Attendance.Status.Id],
									ContactPerson, 
									LocationAddress, 
									Products,									
									Comments,
									[CreateBy.Security.User.Id])
			VALUES (@DateTime, @ClientRegisterId, @SalesVendorId, @AttendanceTypeId, @AttendanceStatusId, @ContactPerson, @LocationAddress, @Products, @Comments, 1)
				
			IF @@ROWCOUNT = 1
			BEGIN
				COMMIT TRANSACTION
				SELECT @Id = SCOPE_IDENTITY()
				SET @xmlResponse = CAST('<Message><CommitChanges Id="' + CAST(@Id AS NVARCHAR) + '">Os dados foram gravados com sucesso !</CommitChanges></Message>' AS XML)
			END
			ELSE
			BEGIN
				ROLLBACK TRANSACTION
				EXECUTE SMS.ReportError
				SET @xmlResponse = CAST('<Message><Error Id="99">Os Registro de Atendimento não foi atualizado, contate o suporte técnico.</Error></Message>' AS XML)
			END

		END
		ELSE
		BEGIN
			UPDATE Attendance.Register SET	/*[DateTime] = @DateTime, */
										[Sales.Client.Id] = @ClientRegisterId, 
										[Sales.Vendor.Id] = @SalesVendorId, 
										[Attendance.Type.Id] = @AttendanceTypeId, 
										[Attendance.Status.Id] = @AttendanceStatusId,
										ContactPerson = @ContactPerson, 
										LocationAddress = @LocationAddress, 
										Products = @Products,
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
				SET @xmlResponse = CAST('<Message><Error Id="99">Os Registro de Atendimento não foi atualizado, contate o suporte técnico.</Error></Message>' AS XML)
			END
		END
		
		IF (@xmlRequest.exist('/Register/Message/Email') = 1)
		BEGIN
		
			SET @mailTo = @xmlRequest.value('(/Register/Message/Email/Address)[1]', 'NVARCHAR(MAX)')

			IF NOT @mailTo IS NULL
			BEGIN
						
				SET	@body = --'Email: ' + @mailTo  + CHAR(13) + CHAR(13) + */
					N'<HTML><HEADER><TITLE>Solicitação de Atendimento ao Cliente</TITLE></HEADER><BODY><B>Solicitação de Atendimento ao Cliente:</B><BR><BR>' + CHAR(13) + CHAR(13) + 
					N'<TABLE>' + CHAR(13) +
					N'<TR><TD><B>Data: </B></TD>' + '<TD>' + CONVERT(nvarchar, @xmlRequest.value('(/Register/DateTime)[1]', 'DATETIME'), 113) + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD><B>Tipo: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/Type)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13) +
					N'<TR><TD><B>Nome: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/Client/CodeName)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13)			
					
				SELECT	@body = @body + 
						N'<TR><TD><B>Contato: </B></TD>' + '<TD>' + x.item.value('(Name)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13) +
						N'<TR><TD><B>Depto: </B></TD>' + '<TD>' + x.item.value('(Department)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13) +
						N'<TR><TD><B>Telefone(s): </B></TD>' + '<TD>' +
						REPLACE(REPLACE(CAST(x.item.query('for $e in ContactFone/Fone return concat("(", data($e/AreaCode[1]), ") ", data($e/Prefix[1]), "-", data($e/Number[1]), data($e/AccessCode[1]), "<BR>")') AS NVARCHAR(MAX)), '&lt;', '<'), '&gt;', '>') + 
						N'</TD></TR>' + CHAR(13) +
						N'<TR><TD><B>Email(s): </B></TD>' + '<TD>' +
						REPLACE(REPLACE(CAST(x.item.query('for $e in ContactEmail/Email return concat(data($e/Address[1]), "<BR>")') AS NVARCHAR(MAX)), '&lt;', '<'), '&gt;', '>') + 
						N'</TD></TR>' + CHAR(13)
				FROM @xmlRequest.nodes('/Register/ContactPerson/Person') AS x(item)

				SET @body = @body +			
					N'<TR><TD><B>Endereço: </B></TD>' +	'<TD>' + LTRIM(RTRIM(LTRIM(RTRIM(@xmlRequest.value('(/Register/LocationAddress/Address/Street)[1]', 'NVARCHAR(MAX)') + 
							N' ' + @xmlRequest.value('(/Register/LocationAddress/Address/Number)[1]', 'NVARCHAR(50)'))) + 
							N' ' + @xmlRequest.value('(/Register/LocationAddress/Address/Complement)[1]', 'NVARCHAR(50)'))) + '</TD></TR>' + CHAR(13) +
					N'<TR><TD><B>Bairro: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/LocationAddress/Address/District)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13) +
					N'<TR><TD><B>CEP: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/LocationAddress/Address/PostalCode)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13) + 
					N'<TR><TD><B>Cidade: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/LocationAddress/Address/City)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13) 
					--N'<TR><TD><B>Estado: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/LocationAddress/Address/City/State/Name)[1]', 'NVARCHAR(50)') + '</TD></TR>' + CHAR(13)
			
				SELECT @body = @body +					
					N'<TR><TD><B>Produto(s): </B></TD>' + '<TD>' +
					REPLACE(REPLACE(CAST(x.item.query('for $e in Product return concat(data($e/Description[1]), "<BR>")') AS NVARCHAR(MAX)), '&lt;', '<'), '&gt;', '>') + 
					N'</TD></TR>' + CHAR(13)
				FROM @xmlRequest.nodes('/Register/Products') AS x(item)
				
				SET @body = @body +
					N'<TR><TD><B>Observação: </B></TD>' + '<TD>' + @xmlRequest.value('(/Register/Comments)[1]', 'NVARCHAR(MAX)') + '</TD></TR></TABLE><BR>' + CHAR(13) +
					N'<B>*** Enviado automaticamente pelo Sistema de Atendimento ao Cliente da Altamira. ***</B></BODY></HTML>' 
											
				SET @mailTo = @mailTo + ';flaviana.cabral@altamira.com.br'
				
				EXEC [msdb].dbo.sp_send_dbmail
					@profile_name = 'Atendimento',
					@recipients = @mailTo,
					@subject = 'Altamira - Solicitação de Atendimento ao Cliente',
					@body_format = 'HTML',
					@body =	@body;
			END
		END
		
		IF (@xmlRequest.exist('/Register/Message/SMS') = 1)
		BEGIN

			DECLARE @Message XML
			DECLARE @MessageResponse XML

			SET @Message = @xmlRequest.query('/Register/Message/SMS')
			EXEC Attendance.[Message.SMS.Send] @Message, @MessageResponse OUTPUT

		END
		
	END TRY
	BEGIN CATCH
		EXECUTE SMS.ReportError @xmlRequest
		SET @xmlResponse = CAST('<Message><Error Id="1005">Não foi possível gravar, contate o suporte técnico.</Error></Message>' AS XML)
		RETURN 0
	END CATCH
		
	RETURN 1
								
END












