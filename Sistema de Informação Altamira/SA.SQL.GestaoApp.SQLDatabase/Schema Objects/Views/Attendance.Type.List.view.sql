CREATE VIEW [Attendance].[Type.List]
AS
SELECT     
	(SELECT     
		(SELECT Attendance.[Type].Id AS '@Id', 
				Attendance.[Type].[Description] AS 'Description'
		FROM Attendance.[Type] 
		--WHERE Attendance.[Type].[Enable] = 1
		ORDER BY Attendance.[Type].[Description]
		FOR XML PATH('Type'), TYPE) 
	FOR XML PATH('Types'), TYPE) 
AS Xml
















