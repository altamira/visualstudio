CREATE VIEW [Location].[State.List]
AS
SELECT     
	(SELECT     
		(SELECT Location.[State].Id AS '@Id', 
				Location.[State].Name AS 'Name',
				Location.[State].Acronym AS 'Acronym',
				Location.[State].Flag AS 'Flag',
				(SELECT Location.City.Id AS '@Id',
						Location.City.Name AS 'text()'
				FOR XML PATH('Capital'), TYPE),
				(SELECT Location.Country.Id AS '@Id', 
						Location.Country.Name AS 'text()' 
				FOR XML PATH('Country'), TYPE)
		FROM Location.[State] 
		INNER JOIN Location.City
		ON Location.[State].[Location.CityCapital.Id] = Location.City.Id
		INNER JOIN Location.[Country] 
		ON Location.[State].[Location.Country.Id] = Location.[Country].Id
		ORDER BY [State].Name 
		FOR XML PATH('State'), TYPE, BINARY BASE64) 
	FOR XML PATH('States'), TYPE) 
AS Xml















