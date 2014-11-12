CREATE VIEW [Location].[City.List]
AS
SELECT     
	(SELECT     
		(SELECT Location.City.Id AS '@Id', 
				Location.City.Name AS 'Name',
				(SELECT Location.State.Id AS '@Id', 
						Location.State.Name AS 'text()'/*, 
						--Location.State.Acronym AS 'Acronym',
						--Location.State.Flag AS 'Flag' */
				FOR XML PATH('State'), TYPE, BINARY BASE64)
		FROM Location.City 
		INNER JOIN Location.[State] 
		ON Location.City.[Location.State.Id] = Location.[State].Id
		ORDER BY City.Name 
		FOR XML PATH('City'), TYPE) 
	FOR XML PATH('Cities'), TYPE) 
AS Xml











