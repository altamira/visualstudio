-- =============================================
-- Script Template
-- =============================================

--PRINT 'Import Data...'

SET NOCOUNT ON

declare @p2 xml
declare @p3 xml

/*
PRINT 'Insert Sales.Client...'
SET @p2=convert(xml,N'<Client Id="0"><Code>0</Code><CodeName>PLASTROM SENSORMATIC</CodeName><Name/><Vendor Id="19">Alessandro (Teste)</Vendor><Media Id="2">Google</Media><ContactFone/><ContactEmail/><ContactPerson><Person Guid="b341ae3f-0227-4826-8088-06101e50a6a3"><Name>MUNIQUE</Name><Department>Compras</Department><ContactFone><Fone Guid="46ab641e-630f-496d-9a5d-63976a3c1a0e"><AreaCode>11</AreaCode><Prefix>4166</Prefix><Number>4445</Number><AccessCode/><FoneType Id="1">Telefone</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email Guid="0ac3d5d4-8bba-453d-bf23-f2f3063142b5"><Address>mmartins@sensorbrasil.com.br</Address></Email></ContactEmail></Person></ContactPerson><LocationAddress><Address Guid="7c1a4754-68da-4986-81ba-b74a97352d27"><Street>AL.ARAGUAIA</Street><Number>3718</Number><Complement/><District/><PostalCode/><City Id="5427"><Name>São Paulo</Name><Flag/><State Id="11"><Name>São Paulo</Name><Country Id="1"><Name>BRASIL</Name></Country></State></City></Address></LocationAddress></Client>')
EXEC Sales.[Client.CommitChanges] @SessionGuid='00000000-0000-0000-0000-000000000000',@XmlRequest=@p2,@XmlResponse=@p3 OUTPUT

PRINT 'Insert Attendance.Register...'
set @p2=convert(xml,N'<Attendance><Register Id="0"><DateTime>2011-09-01T12:27:39.7839315-03:00</DateTime><Client Id="1"><Code/><CodeName>PLASTROM SENSORMATIC</CodeName><Name/><Vendor Id="19">Alessandro (Teste)</Vendor><Media Id="2">Google</Media><ContactFone/><ContactEmail/><ContactPerson><Person Guid="b341ae3f-0227-4826-8088-06101e50a6a3"><Name>MUNIQUE</Name><Department>Compras</Department><ContactFone><Fone Guid="46ab641e-630f-496d-9a5d-63976a3c1a0e"><AreaCode>11</AreaCode><Prefix>4166</Prefix><Number>4445</Number><AccessCode/><FoneType Id="1">Telefone</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email Guid="0ac3d5d4-8bba-453d-bf23-f2f3063142b5"><Address>mmartins@sensorbrasil.com.br</Address></Email></ContactEmail></Person></ContactPerson><LocationAddress><Address Guid="7c1a4754-68da-4986-81ba-b74a97352d27"><Street>AL.ARAGUAIA</Street><Number>3718</Number><Complement/><District/><PostalCode/><City Id="25"><Name>SAO PAULO</Name><Flag/><State Id="11"><Name>São Paulo</Name><Country Id="1"><Name>BRASIL</Name></Country></State></City></Address></LocationAddress></Client><Vendor Id="19"><Code>099</Code><Name>Alessandro (Teste)</Name><ContactFone><Fone Guid="a52139dc-a057-4ef6-b25c-f95c1be40f23"><AreaCode>11</AreaCode><Prefix>8442</Prefix><Number>0440</Number><AccessCode/><FoneType Id="4">Celular</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email Guid="47970ada-bc09-41a8-a7b3-c4f0ae8de3ba"><Address>alessandrohmachado@gmail.com</Address></Email></ContactEmail><LocationAddress/><ContactPerson/></Vendor><Type Id="13">Negociação de orçamentos</Type><Status Id="25">PENDENTE: Agendou visita, mas o representante não compareceu (Motivo)</Status><ContactPerson><Person Guid="b341ae3f-0227-4826-8088-06101e50a6a3"><Name>MUNIQUE</Name><Department>Compras</Department><ContactFone><Fone Guid="46ab641e-630f-496d-9a5d-63976a3c1a0e"><AreaCode>11</AreaCode><Prefix>4166</Prefix><Number>4445</Number><AccessCode/><FoneType Id="1">Telefone</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email 
Guid="0ac3d5d4-8bba-453d-bf23-f2f3063142b5"><Address>mmartins@sensorbrasil.com.br</Address></Email></ContactEmail></Person></ContactPerson><LocationAddress><Address Guid="7c1a4754-68da-4986-81ba-b74a97352d27"><Street>AL.ARAGUAIA</Street><Number>3718</Number><Complement/><District/><PostalCode/><City Id="25"><Name>SAO PAULO</Name><Flag/><State Id="11"><Name>São Paulo</Name><Country Id="1"><Name>BRASIL</Name></Country></State></City></Address></LocationAddress><Products><Product Guid="840d0c17-cec2-4812-a0d2-1254a92df1d7"><Description>Paineis/Divisórias</Description></Product></Products><Comments>TESTE</Comments><Message><Email Guid="47970ada-bc09-41a8-a7b3-c4f0ae8de3ba"><Address>alessandrohmachado@gmail.com</Address></Email><SMS><Fone Guid="a52139dc-a057-4ef6-b25c-f95c1be40f23"><AreaCode>11</AreaCode><Prefix>8442</Prefix><Number>0440</Number><AccessCode/><FoneType Id="4">Celular</FoneType><Country Id="1">BRASIL</Country></Fone><Text>PLASTROM SENSORMATIC MUNIQUE Compras 4166-4445 AL.ARAGUAIA,3718 SAO PAULO TESTE</Text></SMS></Message></Register></Attendance>')
exec Attendance.[Register.CommitChanges] @SessionGuid='00000000-0000-0000-0000-000000000000',@XmlRequest=@p2,@XmlResponse=@p3 output
*/

PRINT 'Prepare Import...'
/*
set @p2=convert(xml,N'<Bid><Register Id="0"><DateTime>2011-09-05T13:46:14.6373909-03:00</DateTime><Number/><Client Id="1"><Code>0</Code><CodeName>PLASTROM SENSORMATIC</CodeName><Name/><Vendor Id="19">Alessandro (Teste)</Vendor><Media Id="2">Google</Media><ContactFone/><ContactEmail/><ContactPerson><Person Guid="b341ae3f-0227-4826-8088-06101e50a6a3"><Name>MUNIQUE</Name><Department>Compras</Department><ContactFone><Fone Guid="46ab641e-630f-496d-9a5d-63976a3c1a0e"><AreaCode>11</AreaCode><Prefix>4166</Prefix><Number>4445</Number><AccessCode/><FoneType Id="1">Telefone</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email Guid="0ac3d5d4-8bba-453d-bf23-f2f3063142b5"><Address>mmartins@sensorbrasil.com.br</Address></Email></ContactEmail></Person></ContactPerson><LocationAddress><Address Guid="7c1a4754-68da-4986-81ba-b74a97352d27"><Street>AL.ARAGUAIA</Street><Number>3718</Number><Complement/><District/><PostalCode/><City Id="5427"><Name>São Paulo</Name><Flag/><State Id="11"><Name>São Paulo</Name><Country Id="1"><Name>BRASIL</Name></Country></State></City></Address></LocationAddress></Client><Vendor Id="23"><Code>117</Code><Name>Paulo da PJ (Administração)</Name><ContactFone/><ContactEmail/><LocationAddress/><ContactPerson/></Vendor><ContactPerson><Person Guid="b341ae3f-0227-4826-8088-06101e50a6a3"><Name>MUNIQUE</Name><Department>Compras</Department><ContactFone><Fone Guid="46ab641e-630f-496d-9a5d-63976a3c1a0e"><AreaCode>11</AreaCode><Prefix>4166</Prefix><Number>4445</Number><AccessCode/><FoneType Id="1">Telefone</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email Guid="0ac3d5d4-8bba-453d-bf23-f2f3063142b5"><Address>mmartins@sensorbrasil.com.br</Address></Email></ContactEmail></Person></ContactPerson><PurchaseType Id="2">MERCANTIL</PurchaseType><ContactPersonCopyTo><Person Guid="b341ae3f-0227-4826-8088-06101e50a6a3"><Name>MUNIQUE</Name><Department>Compras</Department><ContactFone><Fone Guid="46ab641e-630f-496d-9a5d-63976a3c1a0e"><AreaCode>11</AreaCode><Prefix>4166</Prefix><Number>4445</Number><AccessCode/><FoneType Id="1">Telefone</FoneType><Country Id="1">BRASIL</Country></Fone></ContactFone><ContactEmail><Email Guid="0ac3d5d4-8bba-453d-bf23-f2f3063142b5"><Address>mmartins@sensorbrasil.com.br</Address></Email></ContactEmail></Person></ContactPersonCopyTo><LocationAddress><Address Guid="7c1a4754-68da-4986-81ba-b74a97352d27"><Street>AL.ARAGUAIA</Street><Number>3718</Number><Complement/><District/><PostalCode/><City Id="5427"><Name>São Paulo</Name><Flag/><State Id="11"><Name>São Paulo</Name><Country Id="1"><Name>BRASIL</Name></Country></State></City></Address></LocationAddress><Comments>TESTE</Comments></Register></Bid>')
exec Sales.[Bid.CommitChanges] @SessionGuid='00000000-0000-0000-0000-000000000000',@XmlRequest=@p2,@XmlResponse=@p3 output
*/

/****** Script do comando Import Bid Clientes  ******/

--DELETE FROM Sales.Client
UPDATE Gestao.Sales.Bid SET CountryID = 1 WHERE CountryID = 0
UPDATE Gestao.Sales.Bid SET CountryID1 = 1 WHERE CountryID1 = 0
UPDATE Gestao.Sales.Bid SET CityID = 25 WHERE CityID = 0

UPDATE Gestao.Sales.Bid SET CityID = (SELECT Id FROM Gestao.Location.City WHERE Name = 'SÃO PAULO')
--SELECT City.Name, [State].Acronym, Bid.*
FROM Gestao.Sales.Bid Bid
INNER JOIN Gestao.Location.City City ON Bid.CityID = City.Id
INNER JOIN Gestao.Location.State [State] ON City.StateID = [State].Id
WHERE NOT EXISTS (SELECT * 
					FROM GestaoApp.Location.City C 
					INNER JOIN GestaoApp.Location.State S ON C.[Location.State.Id] = S.Id 
					WHERE C.Name = City.Name AND S.Acronym = [State].Acronym)

UPDATE Gestao.Sales.Bid 
SET ContactName = LTRIM(RTRIM(REPLACE(REPLACE(ContactName, 'SR.', ''), 'SRA.', ''))),
ContactName1 = LTRIM(RTRIM(REPLACE(REPLACE(ContactName1, 'SR.', ''), 'SRA.', '')))

UPDATE [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] 
SET [pror_Contato] = LTRIM(RTRIM(REPLACE(REPLACE([pror_Contato], 'SR.', ''), 'SRA.', '')))

UPDATE DBALTAMIRA.dbo.VE_Recados
SET [vere_Contato] = LTRIM(RTRIM(REPLACE(REPLACE([vere_Contato], 'SR.', ''), 'SRA.', ''))),
[ContactName1] = LTRIM(RTRIM(REPLACE(REPLACE([ContactName1], 'SR.', ''), 'SRA.', '')))

SET NOCOUNT ON

DECLARE @t TABLE(Id INT IDENTITY(1,1), Request XML)
DECLARE @XmlRequest XML
DECLARE @XmlResponse XML
DECLARE @Session UNIQUEIDENTIFIER

SET @Session = NEWID()

PRINT 'Import Sales.Client...'

INSERT INTO @t
SELECT t2.x.query('.') 
FROM [GestaoApp].[dbo].[Gestao.Sales.Bid.Client] AS t
CROSS APPLY [Xml].nodes('/Client') as t2(x)

WHILE (EXISTS(SELECT * FROM @t))
BEGIN
	SET @xmlRequest = (SELECT TOP 1 Request FROM @t ORDER BY Id)
	EXEC Sales.[Client.CommitChanges] @Session, @XmlRequest, @XmlResponse OUTPUT
	IF @xmlResponse.exist('/Message/Error') > 0
	BEGIN
		SELECT @XmlResponse, @XmlRequest
	END
	DELETE FROM @t WHERE Id = (SELECT TOP 1 Id FROM @t ORDER BY Id)
END

PRINT 'Import Sales.Bid...'

INSERT INTO @t
SELECT t2.x.query('.') 
FROM [GestaoApp].[dbo].[Gestao.Sales.Bid] AS t
CROSS APPLY [Xml].nodes('/Register') as t2(x)

WHILE (EXISTS(SELECT * FROM @t))
BEGIN
	SET @xmlRequest = (SELECT TOP 1 Request FROM @t ORDER BY Id)
	EXEC Sales.[Bid.Import] @Session, @XmlRequest, @XmlResponse OUTPUT
	IF @xmlResponse.exist('/Message/Error') > 0
	BEGIN
		SELECT @XmlResponse, @XmlRequest
	END
	DELETE FROM @t WHERE Id = (SELECT TOP 1 Id FROM @t ORDER BY Id)
END

PRINT 'Import DBALTAMIRA.PRE_Orcamentos...'

INSERT INTO @t
SELECT t2.x.query('.') 
FROM [GestaoApp].[dbo].[DBALTAMIRA.PRE_Orcamentos] AS t
CROSS APPLY [Xml].nodes('/Register') as t2(x)

WHILE (EXISTS(SELECT * FROM @t))
BEGIN
	SET @xmlRequest = (SELECT TOP 1 Request FROM @t ORDER BY Id)
	EXEC Sales.[Bid.Import] @Session, @XmlRequest, @XmlResponse OUTPUT
	IF @xmlResponse.exist('/Message/Error') > 0
	BEGIN
		SELECT @XmlResponse, @XmlRequest
	END
	DELETE FROM @t WHERE Id = (SELECT TOP 1 Id FROM @t ORDER BY Id)
END

PRINT 'Import DBALTAMIRA.VE_Recados...'

INSERT INTO @t
SELECT t2.x.query('.') 
FROM [GestaoApp].[dbo].[DBALTAMIRA.VE_Recados] AS t
CROSS APPLY [Xml].nodes('/Register') as t2(x)

WHILE (EXISTS(SELECT * FROM @t))
BEGIN
	SET @xmlRequest = (SELECT TOP 1 Request FROM @t ORDER BY Id)
	EXEC Attendance.[Register.CommitChanges] @Session, @XmlRequest, @XmlResponse OUTPUT
	IF @xmlResponse.exist('/Message/Error') > 0
	BEGIN
		SELECT @XmlResponse, @XmlRequest
	END
	DELETE FROM @t WHERE Id = (SELECT TOP 1 Id FROM @t ORDER BY Id)
END

PRINT 'Import GPIMAC Data...'


