CREATE VIEW [Attendance].[Product.List]
AS
SELECT     
	(SELECT     
		(SELECT Product.Id AS '@Id', 
				Product.[Description] AS 'Description'
		FROM [Attendance].Product Product
		ORDER BY Product.[Description]
		FOR XML PATH('Product'), TYPE) 
	FOR XML PATH('Products'), TYPE) 
AS Xml









