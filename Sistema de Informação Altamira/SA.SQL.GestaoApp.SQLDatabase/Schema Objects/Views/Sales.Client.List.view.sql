CREATE VIEW [Sales].[Client.List]
AS
SELECT     
	(SELECT     
		(SELECT Client.Id AS '@Id',
				Client.CodeName AS 'CodeName',
				Client.ContactPerson AS 'ContactPerson',
				Client.LocationAddress AS 'LocationAddress',
				(SELECT 
					Vendor.Id AS '@Id',
					Vendor.Name
				FOR XML PATH('Vendor'), TYPE),
				(SELECT 
					Media.Id AS '@Id',
					Media.[Description]
				FOR XML PATH('Media'), TYPE)
		FROM Sales.Client Client
		INNER JOIN Sales.Vendor Vendor ON Vendor.Id = Client.[Sales.Vendor.Id]
		INNER JOIN Contact.Media Media ON Media.Id = [Contact.Media.Id]
		ORDER BY Client.CodeName
		FOR XML PATH('Client'), TYPE) 
	FOR XML PATH('Clients'), TYPE) 
AS Xml


















