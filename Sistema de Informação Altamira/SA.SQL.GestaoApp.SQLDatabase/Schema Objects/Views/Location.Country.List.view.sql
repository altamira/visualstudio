CREATE VIEW [Location].[Country.List]
AS
SELECT     
	(SELECT     
		(SELECT Location.Country.Id AS '@Id', 
				Location.Country.Name AS 'Name',
				Location.Country.Flag AS 'Flag' 
		FROM Location.[Country] 
		ORDER BY [Country].Name 
		FOR XML PATH('Country'), TYPE, BINARY BASE64) 
	FOR XML PATH('Countries'), TYPE) 
AS Xml













