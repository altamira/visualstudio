-- =============================================
-- Script Template
-- =============================================

CREATE VIEW [dbo].[Gestao.Sales.Bid]
AS
SELECT
--(SELECT 
	(SELECT 
		0 AS '@Id',   
		Bid.[Date] AS 'DateTime',
		LTRIM(RTRIM(Bid.Code)) AS 'Number',	
		(SELECT 
				Client.Id AS '@Id', 
				Client.CodeName AS 'text()'
		FOR XML PATH('Client'), TYPE),
		(SELECT 
				Vendor.Id AS '@Id', 
				Vendor.Name AS 'text()'
		FOR XML PATH('Vendor'), TYPE),
		(SELECT 
			Client.ContactPerson.query('(/Person[Name=sql:column("Bid.ContactName")])[1]')
		FOR XML PATH('ContactPerson'), TYPE),
		(SELECT PurchaseType.Id AS '@Id',
				PurchaseType.[Description] AS 'text()'
		FOR XML PATH('PurchaseType'), TYPE),
		(SELECT ''
		FOR XML PATH('ContactPersonCopyTo'), TYPE),
		(SELECT 
			Client.LocationAddress.query('(/Address/City[text()=sql:column("City.Name")]/..[Street=sql:column("Bid.Street")])[1]')
		FOR XML PATH('LocationAddress'), TYPE),
		CASE WHEN Comments IS NULL THEN '' ELSE Comments END AS Comments
	FROM [Sales].[Bid] Bid
	INNER JOIN Sales.Client Client ON Client.CodeName = Bid.Name
	INNER JOIN Sales.Vendor Vendor ON LTRIM(RTRIM(Vendor.Code)) = LTRIM(RTRIM(Bid.VendorID))
	INNER JOIN Sales.PurchaseType PurchaseType ON PurchaseType.Id = Bid.PurchaseType
	INNER JOIN Gestao.Location.City C ON Bid.CityID = C.Id
	INNER JOIN Gestao.Location.State S ON C.StateID = S.Id
	INNER JOIN Location.City City ON City.Name = C.Name
	INNER JOIN Location.State [State] ON City.[Location.State.Id] = [State].Id AND [State].Acronym = S.Acronym
	--WHERE 
		/*LEFT(LTRIM(RTRIM(Bid.Name)), 1) = 'A' */
		--LTRIM(RTRIM(Bid.Name)) LIKE 'LOJAS AMERICANAS%' 
		--OR LTRIM(RTRIM(Bid.Name)) LIKE 'IRON MOUNTAIN%'
	ORDER BY Bid.[Date] 
	FOR XML PATH('Register'), TYPE)
--FOR XML PATH('Bid'), TYPE)
AS Xml








