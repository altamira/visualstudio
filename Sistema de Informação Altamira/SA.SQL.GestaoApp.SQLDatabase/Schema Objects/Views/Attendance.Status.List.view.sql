CREATE VIEW [Attendance].[Status.List]
AS
SELECT     
	(SELECT     
		(SELECT [Status].Id AS '@Id', 
				[Group].[Description] + ': ' + [Status].[Description] AS 'Description',
				(SELECT [Group].Id AS '@Id',
						[Group].[Description] AS 'Description'
				FOR XML PATH('Status.Group'), TYPE)
		FROM	Attendance.[Status] [Status]
		INNER JOIN Attendance.[Status.Group] [Group]
		ON [Status].[Status.Group.Id] = [Group].Id
		--WHERE [Status].Enable = 1
		ORDER BY [Status].[Description] 
		FOR XML PATH('Status'), TYPE) 
	FOR XML PATH('State'), TYPE) 
AS Xml











