CREATE VIEW [Contact].[Media.List]
AS
SELECT     
	(SELECT     
		(SELECT Id AS '@Id', 
				[Description] AS 'Description'
		FROM Contact.Media 
		ORDER BY [Description] 
		FOR XML PATH('Media'), TYPE) 
	FOR XML PATH('Medias'), TYPE) 
AS Xml









