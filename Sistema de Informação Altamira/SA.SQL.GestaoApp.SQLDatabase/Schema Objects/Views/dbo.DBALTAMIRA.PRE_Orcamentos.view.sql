CREATE VIEW [dbo].[DBALTAMIRA.PRE_Orcamentos]
AS
SELECT
--(SELECT 
	(SELECT 
		0 AS '@Id',   
		Bid.[pror_DataDigitação] AS 'DateTime',
		REPLACE(STR(Bid.[pror_Numero], 8, 0), ' ', '0') AS 'Number',
		(SELECT 
				Client.Id AS '@Id', 
				Client.CodeName AS 'text()'
		FOR XML PATH('Client'), TYPE),
		(SELECT 
				Vendor.Id AS '@Id', 
				Vendor.Name AS 'text()'
		FROM Sales.Vendor Vendor WHERE LTRIM(RTRIM(Vendor.Code)) = LTRIM(RTRIM(Bid.[pror_Representante]))
		FOR XML PATH('Vendor'), TYPE),
		(SELECT 
			Client.ContactPerson.query('(/Person[Name=sql:column("Bid.[pror_Contato]")])[1]')
		FOR XML PATH('ContactPerson'), TYPE),
		(SELECT PurchaseType.Id AS '@Id',
				PurchaseType.[Description] AS 'text()'
		FROM Sales.PurchaseType PurchaseType WHERE PurchaseType.Id = 2 -- MERCANTIL
		FOR XML PATH('PurchaseType'), TYPE),
		(SELECT ''
		FOR XML PATH('ContactPersonCopyTo'), TYPE),
		(SELECT 
			Client.LocationAddress.query('(/Address/City[text()=sql:column("City.Name")]/..[Street=sql:column("Bid.[pror_Endereço]")])[1]')
		FROM Location.City City INNER JOIN Location.State [State] ON City.[Location.State.Id] = [State].Id
		WHERE City.Name = LTRIM(RTRIM(Bid.[pror_Cidade])) AND [State].Acronym = LTRIM(RTRIM(Bid.[pror_Estado]))
		FOR XML PATH('LocationAddress'), TYPE),
		CASE WHEN Bid.[pror_Observacao] IS NULL THEN '' ELSE Bid.[pror_Observacao] END AS Comments
	FROM [$(DBALTAMIRA)].dbo.PRE_ORCAMENTOS Bid INNER JOIN Sales.Client Client ON Client.CodeName = Bid.[pror_NomeCliente]
	WHERE 
		LEN(LTRIM(RTRIM(Bid.[pror_NomeCliente]))) > 0
		AND NOT EXISTS (SELECT * FROM Gestao.Sales.Bid B WHERE CAST(B.Code AS INT) = Bid.[pror_Numero])
		--AND (/*LEFT(LTRIM(RTRIM(Bid.[pror_NomeCliente])), 1) = 'A' OR*/
		--LTRIM(RTRIM(Bid.[pror_NomeCliente])) LIKE 'LOJAS AMERICANAS%' 
		--OR LTRIM(RTRIM(Bid.[pror_NomeCliente])) LIKE 'IRON MOUNTAIN%')
	ORDER BY Bid.[pror_DataDigitação] DESC
	FOR XML PATH('Register'), TYPE)
--FOR XML PATH('Bid'), TYPE)
AS Xml








