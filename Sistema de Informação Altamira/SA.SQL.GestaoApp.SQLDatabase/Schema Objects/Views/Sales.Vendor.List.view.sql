CREATE VIEW [Sales].[Vendor.List]
AS
SELECT     
	(SELECT     
		(SELECT Id AS '@Id', 
				Code AS 'Code',
				Name AS 'Name',
				ContactFone AS 'ContactFone',
				ContactEmail AS 'ContactEmail'
		FROM Sales.Vendor 
		ORDER BY Code, Name
		FOR XML PATH('Vendor'), TYPE) 
	FOR XML PATH('Vendors'), TYPE) 
AS Xml
















