-- =============================================
-- Script Template
-- =============================================

CREATE VIEW [dbo].[Gestao.Sales.Bid.Client]
AS
SELECT     
	(SELECT 0 AS '@Id', 
		Client.Name AS 'CodeName',
		(SELECT 
				Vendor.Id AS '@Id', 
				Vendor.Name AS 'text()'
			FROM Sales.Vendor Vendor
			WHERE LTRIM(RTRIM(Vendor.Code)) = LTRIM(RTRIM(MIN(Client.Vendor)))
			FOR XML PATH('Vendor'), TYPE),
		(SELECT TOP 1 Id AS '@Id', Media.[Description] AS 'text()'
			FROM Contact.Media Media
			WHERE Media.[Description] = LTRIM(RTRIM(MIN(Client.Media)))
			FOR XML PATH('Media'), TYPE),
		(SELECT 
			(SELECT 
				NEWID() AS '@Guid',
				[Client.Contact].ContactName AS 'Name',
				[Client.Contact].Department AS 'Department',
				(SELECT 
					(SELECT
						NEWID() AS '@Guid',
						[Client.ContactFone].AreaCode AS 'AreaCode',
						[Client.ContactFone].Prefix AS 'Prefix', 
						[Client.ContactFone].FoneNumber AS 'Number',
						[Client.ContactFone].AccessCode AS 'AccessCode', 
						(SELECT 
							FoneType.Id AS '@Id',
							FoneType.[Description] AS 'text()'
						FROM Contact.FoneType FoneType
						WHERE FoneType.[Description] = (SELECT [Description] FROM Gestao.Contact.FoneType WHERE Id = [Client.ContactFone].FoneTypeID)
						FOR XML PATH('FoneType'), TYPE),
						(SELECT 
							Country.Id AS '@Id',
							Country.Name AS 'text()'
						FROM Location.Country Country
						WHERE Country.Name = (SELECT TOP 1 Name FROM Gestao.Location.Country WHERE Id = [Client.ContactFone].CountryID)
						FOR XML PATH('Country'), TYPE)	
					FROM 
						(SELECT /*TOP 0*/
							LTRIM(RTRIM(Bid.Name)) AS Name, 
							CASE WHEN Bid.ContactName IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName)) END AS ContactName,
							CASE WHEN Bid.Department IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department)) END AS Department,	
							CASE WHEN Bid.AreaCode IS NULL THEN '' ELSE 
								CASE WHEN ISNUMERIC(LTRIM(RTRIM(Bid.AreaCode))) = 1 THEN CONVERT(NVARCHAR(4), CONVERT(INT, LTRIM(RTRIM(REPLACE(Bid.AreaCode, ',', ''))))) ELSE LTRIM(RTRIM(Bid.AreaCode)) END END AS AreaCode, 
							CASE WHEN Bid.Prefix IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Prefix)) END Prefix, 
							CASE WHEN Bid.FoneNumber IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.FoneNumber)) END FoneNumber, 
							CASE WHEN Bid.AccessCode IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.AccessCode)) END AccessCode, 
							Bid.FoneTypeID, 
							Bid.CountryID 
						FROM Gestao.Sales.Bid Bid
						WHERE
							LTRIM(RTRIM(Bid.Name)) = Client.Name AND 
							CASE WHEN Bid.ContactName IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName)) END = [Client.Contact].ContactName AND
							CASE WHEN Bid.Department IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Bid.Prefix))) > 0 AND 
							LEN(LTRIM(RTRIM(Bid.FoneNumber))) > 0
						UNION
						SELECT	CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END
								AS Name,
								CASE WHEN Recado.vere_Contato IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Contato)) END AS ContactName,
								CASE WHEN Recado.vere_Departamento IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Departamento)) END AS Department,
								CASE WHEN Recado.vere_DDD IS NULL THEN '' ELSE 
									CASE WHEN ISNUMERIC(LTRIM(RTRIM(Recado.vere_DDD))) = 1 THEN CONVERT(NVARCHAR(4), CONVERT(INT, REPLACE(LTRIM(RTRIM(Recado.vere_DDD)), ',', ''))) ELSE LTRIM(RTRIM(Recado.vere_DDD)) END END AS AreaCode,
								CASE WHEN Recado.vere_Telefone IS NULL THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Recado.vere_Telefone, '-', ''), ' ', ''), '.', ''), ',', ''), 4) END AS Prefix,
								CASE WHEN Recado.vere_Telefone IS NULL THEN '' ELSE RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(Recado.vere_Telefone, '-', ''), ' ', ''), '.', ''), ',', ''), 4) END AS FoneNumber,
								CASE WHEN Recado.vere_Ramal IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Ramal)) END AS AccessCode,
								1 AS FoneTypeID,
								1 AS CountryID
						FROM DBALTAMIRA.dbo.VE_Recados Recado
						WHERE
							CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END = Client.Name AND 
							CASE WHEN Recado.vere_Contato IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Contato)) END = [Client.Contact].ContactName AND
							CASE WHEN Recado.vere_Departamento IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Departamento)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Recado.vere_Telefone))) > 0 AND 
							LEN(REPLACE(REPLACE(REPLACE(REPLACE(Recado.vere_Telefone, '-', ''), ' ', ''), '.', ''), ',', '')) = 8
						UNION
						SELECT /*TOP 0*/
							LTRIM(RTRIM(Bid.Name)) AS Name, 
							CASE WHEN Bid.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName1)) END AS ContactName,						
							CASE WHEN Bid.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department1)) END AS Department,	
							CASE WHEN Bid.AreaCode1 IS NULL THEN '' ELSE 
									CASE WHEN ISNUMERIC(LTRIM(RTRIM(Bid.AreaCode1))) = 1 THEN CONVERT(NVARCHAR(4), CONVERT(INT, REPLACE(LTRIM(RTRIM(Bid.AreaCode1)), ',', ''))) ELSE LTRIM(RTRIM(Bid.AreaCode1)) END END AS AreaCode, 
							CASE WHEN Bid.Prefix1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Prefix1)) END Prefix, 
							CASE WHEN Bid.FoneNumber1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.FoneNumber1)) END FoneNumber, 
							CASE WHEN Bid.AccessCode1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.AccessCode1)) END AccessCode, 
							Bid.FoneTypeID, 
							Bid.CountryID
						FROM Gestao.Sales.Bid Bid
						WHERE
							LTRIM(RTRIM(Bid.Name)) = Client.Name AND 
							CASE WHEN Bid.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName1)) END = [Client.Contact].ContactName AND
							CASE WHEN Bid.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department1)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Bid.Prefix1))) > 0 AND 
							LEN(LTRIM(RTRIM(Bid.FoneNumber1))) > 0
						UNION
						SELECT	CASE 
								WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
								THEN LTRIM(RTRIM(Recado.vere_Abreviado))
								ELSE LTRIM(RTRIM(Recado.vere_Nome)) END
							AS Name,
							CASE WHEN Recado.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.ContactName1)) END AS ContactName,
							CASE WHEN Recado.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.Department1)) END AS Department,
							CASE WHEN Recado.AreaCode1 IS NULL THEN '' ELSE 
								CASE WHEN ISNUMERIC(LTRIM(RTRIM(Recado.AreaCode1))) = 1 THEN CONVERT(NVARCHAR(4), CONVERT(INT, REPLACE(LTRIM(RTRIM(Recado.AreaCode1)), ',', ''))) ELSE LTRIM(RTRIM(Recado.AreaCode1)) END END AS AreaCode,
							CASE WHEN Recado.Prefix1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.Prefix1)) END AS Prefix,
							CASE WHEN Recado.FoneNumber1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.FoneNumber1)) END AS FoneNumber,
							CASE WHEN Recado.AccessCode1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.AccessCode1)) END AS AccessCode,
							1 AS FoneTypeID1,
							1 AS CountryID1
						FROM DBALTAMIRA.dbo.VE_Recados Recado
						WHERE
							CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END = Client.Name AND 
							CASE WHEN Recado.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.ContactName1)) END = [Client.Contact].ContactName AND
							CASE WHEN Recado.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.Department1)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Recado.Prefix1))) > 0 AND 
							LEN(LTRIM(RTRIM(Recado.FoneNumber1))) > 0 
						UNION
						SELECT 
							CASE WHEN Orcamento.[pror_NomeCliente] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) END AS Name,
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END AS ContactName,
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END AS Department,
							CASE WHEN Orcamento.[pror_DDD1] IS NULL THEN '' ELSE 
								CASE WHEN ISNUMERIC(LTRIM(RTRIM(Orcamento.[pror_DDD1]))) = 1 THEN CONVERT(NVARCHAR(4), CONVERT(INT, REPLACE(LTRIM(RTRIM(Orcamento.[pror_DDD1])), ',', ''))) ELSE LTRIM(RTRIM(Orcamento.[pror_DDD1])) END END AS AreaCode,
							CASE WHEN Orcamento.[pror_Telefone1] IS NULL THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Orcamento.[pror_Telefone1], '-', ''), ' ', ''), '.', ''), ',', ''), 4) END AS Prefix,
							CASE WHEN Orcamento.[pror_Telefone1] IS NULL THEN '' ELSE RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(Orcamento.[pror_Telefone1], '-', ''), ' ', ''), '.', ''), ',', ''), 4) END AS FoneNumber,
							'' AS AccessCode,
							1 AS FoneTypeID1,
							1 AS CountryID1							
						FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
						WHERE
							LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) = Client.Name AND
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END = [Client.Contact].ContactName AND 
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END = [Client.Contact].Department AND 
							LEN(REPLACE(REPLACE(REPLACE(REPLACE(Orcamento.[pror_Telefone1], '-', ''), ' ', ''), '.', ''), ',', '')) = 8
						UNION
						SELECT 
							CASE WHEN Orcamento.[pror_NomeCliente] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) END AS Name,
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END AS ContactName,
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END AS Department,
							CASE WHEN Orcamento.[pror_DDD2] IS NULL THEN '' ELSE 
								CASE WHEN ISNUMERIC(LTRIM(RTRIM(Orcamento.[pror_DDD2]))) = 1 THEN CONVERT(NVARCHAR(4), CONVERT(INT, REPLACE(LTRIM(RTRIM(Orcamento.[pror_DDD2])), ',', ''))) ELSE LTRIM(RTRIM(Orcamento.[pror_DDD2])) END END AS AreaCode,
							CASE WHEN Orcamento.[pror_Telefone2] IS NULL THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Orcamento.[pror_Telefone2], '-', ''), ' ', ''), '.', ''), ',', ''), 4) END AS Prefix,
							CASE WHEN Orcamento.[pror_Telefone2] IS NULL THEN '' ELSE RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(Orcamento.[pror_Telefone2], '-', ''), ' ', ''), '.', ''), ',', ''), 4) END AS FoneNumber,
							'' AS AccessCode,
							1 AS FoneTypeID1,
							1 AS CountryID1							
						FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
						WHERE
							LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) = Client.Name AND
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END = [Client.Contact].ContactName AND 
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END = [Client.Contact].Department AND 
							LEN(REPLACE(REPLACE(REPLACE(REPLACE(Orcamento.[pror_Telefone2], '-', ''), ' ', ''), '.', ''), ',', '')) = 8
						) AS [Client.ContactFone]							
					WHERE LTRIM(RTRIM([Client.ContactFone].Name)) = Client.Name AND 
						[Client.ContactFone].ContactName = [Client.Contact].ContactName AND
						[Client.ContactFone].Department = [Client.Contact].Department
					FOR XML PATH('Fone'), TYPE)
				FOR XML PATH('ContactFone'), TYPE),
				(SELECT
					(SELECT 
						NEWID() AS '@Guid',
						[Client.Email].Email AS 'Address'
					FROM 
						(SELECT /*TOP 0*/
							LTRIM(RTRIM(Bid.Name)) AS Name,  
							CASE WHEN Bid.ContactName IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName)) END AS ContactName,
							CASE WHEN Bid.Department IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department)) END AS Department,
							LOWER(LTRIM(RTRIM(Bid.Email))) AS Email
						FROM Sales.Bid Bid
						WHERE
							LTRIM(RTRIM(Bid.Name)) = Client.Name AND 
							CASE WHEN Bid.ContactName IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName)) END = [Client.Contact].ContactName AND
							CASE WHEN Bid.Department IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Bid.Email))) > 0
						UNION
						SELECT	CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END
								AS Name,
								CASE WHEN Recado.vere_Contato IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Contato)) END AS ContactName,
								CASE WHEN Recado.vere_Departamento IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Departamento)) END AS Department,
								CASE WHEN Recado.vere_EMail IS NULL THEN '' ELSE LOWER(LTRIM(RTRIM(Recado.vere_EMail))) END AS Email
						FROM [$(DBALTAMIRA)].dbo.VE_Recados Recado
						WHERE
							CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END = Client.Name AND 
							CASE WHEN Recado.vere_Contato IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Contato)) END = [Client.Contact].ContactName AND
							CASE WHEN Recado.vere_Departamento IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Departamento)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Recado.vere_EMail))) > 0
						UNION
						SELECT /*TOP 0*/
							LTRIM(RTRIM(Bid.Name)) AS Name,  
							CASE WHEN Bid.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName1)) END AS ContactName,
							CASE WHEN Bid.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department1)) END AS Department,
							LOWER(LTRIM(RTRIM(Bid.Email1))) AS Email1
						FROM Gestao.Sales.Bid Bid
						WHERE
							LTRIM(RTRIM(Bid.Name)) = Client.Name AND 
							CASE WHEN Bid.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName1)) END = [Client.Contact].ContactName AND
							CASE WHEN Bid.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department1)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Bid.Email1))) > 0
						UNION
						SELECT	CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END
								AS Name,
								CASE WHEN Recado.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.ContactName1)) END AS ContactName,
								CASE WHEN Recado.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.Department1)) END AS Department,
								CASE WHEN Recado.Email1 IS NULL THEN '' ELSE LOWER(LTRIM(RTRIM(Recado.Email1))) END AS Email
						FROM DBALTAMIRA.dbo.VE_Recados Recado
						WHERE
							CASE 
									WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
									THEN LTRIM(RTRIM(Recado.vere_Abreviado))
									ELSE LTRIM(RTRIM(Recado.vere_Nome)) END = Client.Name AND 
							CASE WHEN Recado.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.ContactName1)) END = [Client.Contact].ContactName AND
							CASE WHEN Recado.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.Department1)) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Recado.Email1))) > 0	
						UNION
						SELECT 
							CASE WHEN Orcamento.[pror_NomeCliente] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) END AS Name,
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END AS ContactName,
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END AS Department,
							CASE WHEN Orcamento.[pror_Email1] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Email1])) END AS Email
						FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
						WHERE
							LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) = Client.Name AND
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END = [Client.Contact].ContactName AND
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Orcamento.[pror_Email1]))) > 0
						UNION
						SELECT 
							CASE WHEN Orcamento.[pror_NomeCliente] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) END AS Name,
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END AS ContactName,
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END AS Department,
							CASE WHEN Orcamento.[pror_Email2] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Email2])) END AS Email
						FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
						WHERE
							LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) = Client.Name AND
							CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END = [Client.Contact].ContactName AND
							CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END = [Client.Contact].Department AND
							LEN(LTRIM(RTRIM(Orcamento.[pror_Email2]))) > 0											
						) AS [Client.Email]						
					WHERE LTRIM(RTRIM([Client.Email].Name)) = Client.Name AND 
						[Client.Contact].ContactName = [Client.Email].ContactName AND
						[Client.Contact].Department = [Client.Email].Department
					FOR XML PATH('Email'), TYPE)
				FOR XML PATH('ContactEmail'), TYPE)
			FROM 
				(SELECT /*TOP 0*/
					LTRIM(RTRIM(Bid.Name)) AS Name, 
					CASE WHEN Bid.ContactName IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName)) END AS ContactName,
					CASE WHEN Bid.Department IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department)) END AS Department
				FROM Gestao.Sales.Bid Bid
				WHERE 
					LTRIM(RTRIM(Bid.Name)) = Client.Name AND
					((LEN(LTRIM(RTRIM(Bid.Prefix))) > 0 AND 
					LEN(LTRIM(RTRIM(Bid.FoneNumber))) > 0) OR
					LEN(LTRIM(RTRIM(Bid.Email))) > 0)
				UNION
				SELECT	CASE 
							WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
							THEN LTRIM(RTRIM(Recado.vere_Abreviado))
							ELSE LTRIM(RTRIM(Recado.vere_Nome)) END
						AS Name,
						CASE WHEN Recado.vere_Contato IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Contato)) END AS ContactName,
						CASE WHEN Recado.vere_Departamento IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Departamento)) END AS Department
				FROM DBALTAMIRA.dbo.VE_Recados Recado
				WHERE 
					CASE 
							WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
							THEN LTRIM(RTRIM(Recado.vere_Abreviado))
							ELSE LTRIM(RTRIM(Recado.vere_Nome)) END = Client.Name AND
					(LEN(LTRIM(RTRIM(Recado.vere_Telefone))) > 0 OR 
					LEN(LTRIM(RTRIM(Recado.vere_EMail))) > 0)							
				UNION
				SELECT /*TOP 0*/
					LTRIM(RTRIM(Bid.Name)) AS Name, 
					CASE WHEN Bid.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.ContactName1)) END AS ContactName,
					CASE WHEN Bid.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Department1)) END AS Department
				FROM Gestao.Sales.Bid Bid
				WHERE 
					LTRIM(RTRIM(Bid.Name)) = Client.Name AND
					((LEN(LTRIM(RTRIM(Bid.Prefix1))) > 0 AND 
					LEN(LTRIM(RTRIM(Bid.FoneNumber1))) > 0) OR
					LEN(LTRIM(RTRIM(Bid.Email1))) > 0)
				UNION
				SELECT	CASE 
							WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
							THEN LTRIM(RTRIM(Recado.vere_Abreviado))
							ELSE LTRIM(RTRIM(Recado.vere_Nome)) END
						AS Name,
						CASE WHEN Recado.ContactName1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.ContactName1)) END AS ContactName,
						CASE WHEN Recado.Department1 IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.Department1)) END AS Department
				FROM DBALTAMIRA.dbo.VE_Recados Recado
				WHERE 
					CASE 
							WHEN LEN(LTRIM(RTRIM(Recado.vere_Abreviado))) > 0
							THEN LTRIM(RTRIM(Recado.vere_Abreviado))
							ELSE LTRIM(RTRIM(Recado.vere_Nome)) END = Client.Name AND
					((LEN(LTRIM(RTRIM(Recado.Prefix1))) > 0 AND 
					LEN(LTRIM(RTRIM(Recado.FoneNumber1))) > 0) OR
					LEN(LTRIM(RTRIM(Recado.Email1))) > 0)	
				UNION
				SELECT 
					CASE WHEN Orcamento.[pror_NomeCliente] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) END AS Name,
					CASE WHEN Orcamento.[pror_Contato] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Contato])) END AS ContactName,
					CASE WHEN Orcamento.[pror_Departamento] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Departamento])) END AS Department
				FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
				WHERE
					LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) = Client.Name AND
					(LEN(LTRIM(RTRIM(Orcamento.[pror_Telefone1]))) > 0 OR 
					LEN(LTRIM(RTRIM(Orcamento.[pror_Email1]))) > 0 OR
					LEN(LTRIM(RTRIM(Orcamento.[pror_Telefone2]))) > 0 OR 
					LEN(LTRIM(RTRIM(Orcamento.[pror_Email2]))) > 0)
				) AS [Client.Contact]								
			FOR XML PATH('Person'), TYPE)
		FOR XML PATH('ContactPerson'), TYPE),
		(SELECT 
			(SELECT 
				NEWID() AS '@Guid',
				'' AS 'Code',
				CASE WHEN [Client.Location].Street IS NULL THEN '' ELSE LTRIM(RTRIM(Street)) END AS 'Street',
				CASE WHEN [Client.Location].AddressNumber IS NULL THEN '' ELSE LTRIM(RTRIM(AddressNumber)) END AS 'Number',
				CASE WHEN [Client.Location].Complement IS NULL THEN '' ELSE LTRIM(RTRIM(Complement)) END 'Complement',
				CASE WHEN [Client.Location].District IS NULL THEN '' ELSE LTRIM(RTRIM(District)) END 'District',
				CASE WHEN [Client.Location].PostalCode IS NULL THEN '' ELSE REPLACE(REPLACE(REPLACE(PostalCode, '-', ''), ' ', ''), '.', '') END 'PostalCode',
				(SELECT 
						Vendor.Id AS '@Id', 
						Vendor.Name AS 'text()'
					FROM Sales.Vendor Vendor
					WHERE LTRIM(RTRIM(Vendor.Code)) = LTRIM(RTRIM([Client.Location].Vendor))
					FOR XML PATH('Vendor'), TYPE),
				(SELECT 
					City.Id AS '@Id',
					City.Name AS 'text()'
				FROM Location.City City 
				INNER JOIN Location.State [State] 
				ON City.[Location.State.Id] = [State].Id
				WHERE City.Name = [Client.Location].CityName
				AND [State].Acronym = [Client.Location].StateUF
				FOR XML PATH('City'), TYPE)
			FROM 
				(SELECT /*TOP 0*/ 
					CASE WHEN Bid.Street IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Street)) END AS Street, 
					CASE WHEN Bid.AddressNumber IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.AddressNumber)) END AS AddressNumber, 
					CASE WHEN Bid.Complement IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.Complement)) END AS Complement, 
					CASE WHEN Bid.District IS NULL THEN '' ELSE LTRIM(RTRIM(Bid.District)) END AS District, 
					CASE WHEN Bid.PostalCode IS NULL THEN '' ELSE REPLACE(REPLACE(REPLACE(Bid.PostalCode, '-', ''), ' ', ''), '.', '') END AS PostalCode, 
					(SELECT C.Name FROM Gestao.Location.City C WHERE C.Id = Bid.CityID) AS CityName, 
					(SELECT S.Acronym FROM Gestao.Location.City C INNER JOIN Gestao.Location.State S ON C.StateID = S.Id WHERE C.Id = Bid.CityID) AS StateUF,
					LTRIM(RTRIM(Bid.VendorID)) AS Vendor
				FROM Gestao.Sales.Bid Bid
				WHERE 
					LTRIM(RTRIM(Bid.Name)) = Client.Name AND 
					EXISTS (SELECT * FROM Location.City City INNER JOIN Location.State [State] ON City.[Location.State.Id] = [State].Id
							INNER JOIN (SELECT C.Name AS CityName, S.Acronym AS StateUF FROM Gestao.Location.City C INNER JOIN Gestao.Location.State S ON C.StateID = S.Id WHERE C.Id = Bid.CityID) AS X
							ON X.CityName = City.Name AND X.StateUF = [State].Acronym)
				UNION
				SELECT	
					CASE WHEN Recado.vere_Endereco IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Endereco)) END AS Street,
					CASE WHEN Recado.vere_EndNumero IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_EndNumero)) END AS AddressNumber,
					CASE WHEN Recado.vere_EndComplemento IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_EndComplemento)) END AS Complement,
					CASE WHEN Recado.vere_Bairro IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Bairro)) END AS District,
					CASE WHEN Recado.vere_CEP IS NULL THEN '' ELSE REPLACE(REPLACE(REPLACE(Recado.vere_CEP, '-', ''), ' ', ''), '.', '') END AS PostalCode,
					CASE WHEN Recado.vere_Cidade IS NULL THEN '' ELSE LTRIM(RTRIM(Recado.vere_Cidade)) END AS CityName,
					(SELECT S.Acronym FROM Gestao.Location.State S WHERE S.Acronym = LTRIM(RTRIM(vere_Estado))) AS StateUF,
					LTRIM(RTRIM(Recado.vere_Representante)) AS Vendor
				FROM DBALTAMIRA.dbo.VE_Recados Recado
				WHERE
					CASE 
							WHEN LEN(LTRIM(RTRIM(vere_Abreviado))) > 0
							THEN LTRIM(RTRIM(vere_Abreviado))
							ELSE LTRIM(RTRIM(vere_Nome)) END = Client.Name AND 
					EXISTS (SELECT * FROM Location.City City 
							INNER JOIN Location.State [State] 
							ON City.[Location.State.Id] = [State].Id
							WHERE City.Name = LTRIM(RTRIM(Recado.vere_Cidade))
							AND [State].Acronym = LTRIM(RTRIM(Recado.vere_Estado)))
				UNION
				SELECT 
					--CASE WHEN Orcamento.[pror_NomeCliente] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) END AS Name,
					CASE WHEN Orcamento.[pror_Endereço] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Endereço])) END AS Street,
					'' AS AddressNumber,
					'' AS Complement,
					CASE WHEN Orcamento.[pror_Bairro] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Bairro])) END AS District,
					CASE WHEN Orcamento.[pror_CEP] IS NULL THEN '' ELSE REPLACE(REPLACE(REPLACE(Orcamento.[pror_CEP], '-', ''), ' ', ''), '.', '') END AS PostalCode,
					CASE WHEN Orcamento.[pror_Cidade] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Cidade])) END AS CityName,
					CASE WHEN Orcamento.[pror_Estado] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Estado])) END AS StateUF,
					CASE WHEN Orcamento.[pror_Representante] IS NULL THEN '' ELSE LTRIM(RTRIM(Orcamento.[pror_Representante])) END AS Vendor
				FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
				WHERE
					LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) = Client.Name AND 
					EXISTS (SELECT * FROM Location.City City 
							INNER JOIN Location.State [State] 
							ON City.[Location.State.Id] = [State].Id
							WHERE City.Name = LTRIM(RTRIM(Orcamento.[pror_Cidade]))
							AND [State].Acronym = LTRIM(RTRIM(Orcamento.[pror_Estado])))
				/*UNION
				SELECT
					CASE WHEN PreCliente.[Codigo] IS NULL THEN '' ELSE CAST(PreCliente.[Codigo] AS NVARCHAR(MAX)) END AS Code,
					CASE WHEN PreCliente.[CNPJ] IS NULL THEN '' ELSE PreCliente.[CNPJ] END AS CNPJ,
					CASE WHEN PreCliente.[Nome] IS NULL THEN '' ELSE PreCliente.[Nome] END AS Name,
					CASE WHEN PreCliente.[Endereco.TipoLogradouro.Codigo] IS NULL THEN '' ELSE LTRIM(RTRIM(PreCliente.[Endereco.TipoLogradouro.Codigo] + ' ' + PreCliente.[Endereco.Logradouro])) END AS Street,
					CASE WHEN PreCliente.[Endereco.Numero] IS NULL THEN '' ELSE  LTRIM(RTRIM(PreCliente.[Endereco.Numero])) END AS AddressNumber,
					CASE WHEN PreCliente.[Endereco.Complemento] IS NULL THEN '' ELSE  LTRIM(RTRIM(PreCliente.[Endereco.Complemento])) END AS Complement,
					CASE WHEN PreCliente.[Endereco.Bairro] IS NULL THEN '' ELSE LTRIM(RTRIM(PreCliente.[Endereco.Bairro])) END AS District,
					CASE WHEN PreCliente.[Endereco.CodigoPostal] IS NULL THEN '' ELSE  REPLACE(REPLACE(PreCliente.[Endereco.CodigoPostal], '-', ''), ' ', '') END AS PostalCode,
					CASE WHEN PreCliente.[Endereco.Cidade] IS NULL THEN '' ELSE  LTRIM(RTRIM(PreCliente.[Endereco.Cidade])) END AS CityName,
					CASE WHEN PreCliente.[Endereco.UF] IS NULL THEN '' ELSE  LTRIM(RTRIM(PreCliente.[Endereco.UF])) END AS StateUF,
					CASE WHEN PreCliente.[Vendedor.Codigo] IS NULL THEN '' ELSE  LTRIM(RTRIM(PreCliente.[Vendedor.Codigo])) END AS Vendor
				FROM [dbo].[GPIMAC.PreCliente] PreCliente
				WHERE LTRIM(RTRIM(PreCliente.[NomeFantasia])) = Client.Name AND 
					EXISTS (SELECT * FROM Location.City City 
							INNER JOIN Location.State [State] 
							ON City.[Location.State.Id] = [State].Id
							WHERE City.Name =LTRIM(RTRIM(PreCliente.[Endereco.Cidade]))
							AND [State].Acronym = LTRIM(RTRIM(PreCliente.[Endereco.UF])))*/
				) AS [Client.Location]
			FOR XML PATH('Address'), TYPE)
		FOR XML PATH('LocationAddress'), TYPE)
	FROM 
		(SELECT /*TOP 0*/
			LTRIM(RTRIM(Bid.Name)) AS Name,
			LTRIM(RTRIM(Bid.VendorID)) AS Vendor,
			(SELECT TOP 1 [Description] FROM Gestao.sales.Publicity) AS Media
		FROM Gestao.Sales.Bid Bid
		WHERE 
			LEN(LTRIM(RTRIM(Bid.Name))) > 0
		UNION
		SELECT /*TOP 0*/
			CASE 
				WHEN LEN(LTRIM(RTRIM(vere_Abreviado))) > 0
				THEN LTRIM(RTRIM(vere_Abreviado))
				ELSE LTRIM(RTRIM(vere_Nome)) END
			AS Name,
			LTRIM(RTRIM(vere_Representante)) AS Vendor,
			LTRIM(RTRIM(P.[Description])) AS Media
		FROM DBALTAMIRA.dbo.VE_Recados LEFT JOIN Gestao.sales.Publicity P ON vere_Propaganda = P.Id
		WHERE	LEN(LTRIM(RTRIM(vere_Abreviado))) > 0 OR
				LEN(LTRIM(RTRIM(vere_Nome))) > 0
		UNION
		SELECT /*TOP 10*/
			LTRIM(RTRIM(Orcamento.[pror_NomeCliente])) AS Name, 
			LTRIM(RTRIM(Orcamento.[pror_Representante])) AS Vendor, 
			(SELECT TOP 1 [Description] FROM Gestao.Sales.Publicity) AS Media 
		FROM [DBALTAMIRA].[dbo].[PRE_ORCAMENTOS] Orcamento
		WHERE 
			LEN(LTRIM(RTRIM(Orcamento.[pror_NomeCliente]))) > 0
			AND NOT EXISTS (SELECT * FROM Gestao.Sales.Bid WHERE CAST(Code AS INT) = [pror_Numero])
		/*UNION
		SELECT /*TOP 10*/
			LTRIM(RTRIM(GPIMAC.[NomeFantasia])) AS Name, 
			LTRIM(RTRIM(GPIMAC.[Vendedor.Codigo])) AS Vendor, 
			(SELECT TOP 1 [Description] FROM Gestao.Sales.Publicity) AS Media 
		FROM [dbo].[GPIMAC.PreCliente] GPIMAC
		WHERE 
			LEN(LTRIM(RTRIM(GPIMAC.[NomeFantasia]))) > 0*/
		) AS Client
	--WHERE LTRIM(RTRIM(Client.Name)) = 'CHAMA SUPERMERCADOS'
	--WHERE 
		--LTRIM(RTRIM(Client.Name)) LIKE 'LOJAS AMERICANAS%' OR
		--LTRIM(RTRIM(Client.Name)) LIKE 'IRON MOUNTAIN%'
		--LEFT(LTRIM(RTRIM(Client.Name)), 1) = 'A'
	GROUP BY Client.Name
	--ORDER BY Client.Name
	FOR XML PATH('Client'), TYPE)
AS Xml








