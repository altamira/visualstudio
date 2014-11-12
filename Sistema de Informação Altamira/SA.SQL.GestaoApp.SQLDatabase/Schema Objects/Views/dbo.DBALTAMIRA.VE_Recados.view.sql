CREATE VIEW [dbo].[DBALTAMIRA.VE_Recados]
AS 
SELECT
--(SELECT 
	(SELECT 
		0 AS '@Id',   
		Recado.[vere_Data] AS 'DateTime',
		(SELECT 
				Client.Id AS '@Id', 
				Client.CodeName AS 'text()'
		FOR XML PATH('Client'), TYPE),
		(SELECT 
				Vendor.Id AS '@Id', 
				Vendor.Name AS 'text()'
		FROM Sales.Vendor Vendor WHERE LTRIM(RTRIM(Vendor.Code)) = LTRIM(RTRIM(Recado.[vere_Representante]))
		FOR XML PATH('Vendor'), TYPE),
		(SELECT 
				[Type].Id AS '@Id',
				[Type].[Description] AS 'text()'
		FROM Attendance.[Type] [Type] WHERE [Type].[Description] = LTRIM(RTRIM(Recado.[vere_TipoDoRecado]))
		FOR XML PATH('Type'), TYPE),
		(SELECT 
				[Status].Id AS '@Id',
				[Status].[Description] AS 'text()'
		FROM Attendance.[Status] [Status] WHERE [Status].[Description] = LTRIM(RTRIM(Recado.[vere_SituaçãoDoRecado]))
		FOR XML PATH('Status'), TYPE),
		(SELECT 
			Client.ContactPerson.query('(/Person[Name=sql:column("Recado.[vere_Contato]")])[1]')
		FOR XML PATH('ContactPerson'), TYPE),
		(SELECT 
			Client.LocationAddress.query('(/Address/City[text()=sql:column("City.Name")]/..[Street=sql:column("Recado.[vere_Endereco]")])[1]')
		FROM Location.City City 
		INNER JOIN Location.State [State] ON City.[Location.State.Id] = [State].Id 
		WHERE City.Name = LTRIM(RTRIM(Recado.[vere_Cidade])) AND [State].Acronym = LTRIM(RTRIM(Recado.[vere_Estado]))
		FOR XML PATH('LocationAddress'), TYPE),
		(SELECT 
			(SELECT
				Product.Id AS '@Id',
				Product.[Description] AS 'text()'
			FROM [Attendance].[Product] Product 
			WHERE Product.Id = Recado.Product
			FOR XML PATH('Product'), TYPE)
		FOR XML PATH('Products'), TYPE),
		CASE WHEN Recado.[vere_Observacao] IS NULL THEN '' ELSE Recado.[vere_Observacao] END AS Comments
	FROM [$(DBALTAMIRA)].dbo.VE_Recados AS Recado
	INNER JOIN Sales.Client Client 
	ON Client.CodeName = CASE 
			WHEN LEN(LTRIM(RTRIM(Recado.[vere_Abreviado]))) > 0
			THEN LTRIM(RTRIM(Recado.[vere_Abreviado]))
			ELSE LTRIM(RTRIM(Recado.[vere_Nome])) END
	WHERE 
		LEN(LTRIM(RTRIM(vere_Abreviado))) > 0 OR LEN(LTRIM(RTRIM(vere_Nome))) > 0
		/*AND (CASE 
			WHEN LEN(LTRIM(RTRIM(Recado.[vere_Abreviado]))) > 0
			THEN LTRIM(RTRIM(Recado.[vere_Abreviado]))
			ELSE LTRIM(RTRIM(Recado.[vere_Nome])) END LIKE 'LOJAS AMERICANAS%' OR
			CASE 
			WHEN LEN(LTRIM(RTRIM(Recado.[vere_Abreviado]))) > 0
			THEN LTRIM(RTRIM(Recado.[vere_Abreviado]))
			ELSE LTRIM(RTRIM(Recado.[vere_Nome])) END LIKE 'IRON MOUNTAIN%' /*OR
			CASE 
			WHEN LEN(LTRIM(RTRIM(Recado.[vere_Abreviado]))) > 0
			THEN LEFT(LTRIM(RTRIM(Recado.[vere_Abreviado])), 1)
			ELSE LEFT(LTRIM(RTRIM(Recado.[vere_Nome])), 1) END = 'A'*/)*/
	ORDER BY Recado.[vere_Data]
	FOR XML PATH('Register'), TYPE)
--FOR XML PATH('Bid'), TYPE)
AS Xml








