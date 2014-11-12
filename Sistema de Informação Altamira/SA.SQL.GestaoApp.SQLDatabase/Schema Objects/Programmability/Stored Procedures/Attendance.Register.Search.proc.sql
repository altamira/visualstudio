CREATE PROCEDURE [Attendance].[Register.Search]
	@Guid AS UNIQUEIDENTIFIER,
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @Return INT
	DECLARE @Session XML

	EXEC @Return = Security.[Session.Validate] @Guid, NULL, @Session OUTPUT
	
	IF @Return <> 1
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado !</Error></Message>' AS XML)
		RETURN 0
	END
	
	IF	@Session IS NULL OR
		@Session.exist('(/Session)[1]') <> 1 OR
		NOT (PATINDEX('%Attendance Register%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
		LTRIM(RTRIM(@Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)'))) = '*')
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado !</Error></Message>' AS XML)
		RETURN 0
	END
	
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @QueryString NVARCHAR(MAX)
	
	SET @StartDate = @xmlRequest.value('(/Query/@StartDate)[1]', 'DATETIME')	
	SET @EndDate = @xmlRequest.value('(/Query/@EndDate)[1]', 'DATETIME')	
	SET @QueryString = UPPER(@xmlRequest.value('(/Query)[1]', 'VARCHAR(max)'))
	
	SET @xmlResponse =	(SELECT 
							(SELECT TOP 100 Attendance.Id AS '@Id',
									Attendance.[DateTime] AS 'DateTime', 
									(SELECT Client.Id as '@Id',
											Client.CodeName AS 'CodeName',
											Client.ContactPerson, 
											Client.LocationAddress,
											(SELECT 
												Vendor.Id AS '@Id', 
												Vendor.Name AS 'text()'
											FROM Sales.Vendor Vendor
											WHERE Vendor.Id = Client.[Sales.Vendor.Id]
											FOR XML PATH('Vendor'), TYPE), 
											(SELECT 
												Media.Id AS '@Id', 
												Media.[Description] AS 'text()'
											FROM Contact.Media Media
											WHERE Media.Id = Client.[Contact.Media.Id]
											FOR XML PATH('Media'), TYPE)
									FOR XML PATH('Client'), TYPE),
									(SELECT Vendor.Id as '@Id',
											Vendor.Name AS 'text()'
									FOR XML PATH('Vendor'), TYPE),
									(SELECT 
										[Type].Id AS '@Id',
										[Type].[Description] AS 'text()'
									FROM Attendance.[Type] AS [Type]
									WHERE [Type].Id = Attendance.[Attendance.Type.Id]
									FOR XML PATH('Type'), TYPE),  
									(SELECT 
										[Status].Id AS '@Id', 
										[Status].[Description] AS 'text()'
									FROM Attendance.[Status] [Status]
									WHERE [Status].Id = Attendance.[Attendance.Status.Id]
									FOR XML PATH('Status'), TYPE),  
									Attendance.ContactPerson, 
									Attendance.LocationAddress, 
									Attendance.Products,									
									Attendance.Comments
							FROM Attendance.Register Attendance
							INNER JOIN Sales.Client Client ON Client.Id = Attendance.[Sales.Client.Id]
							INNER JOIN Sales.Vendor Vendor ON Vendor.Id = Attendance.[Sales.Vendor.Id]
							WHERE 
								Attendance.[DateTime] BETWEEN @StartDate AND @EndDate AND
								/*((@QueryString = '' AND NOT @StartDate IS NULL AND NOT @EndDate IS NULL) AND 
								(Attendance.[DateTime] BETWEEN @StartDate AND @EndDate))
								OR (*/
								(Client.CodeName LIKE '%' + @QueryString +'%' OR 
								Vendor.Name = @QueryString OR 
								Attendance.LocationAddress.exist('(/Address[City=sql:variable("@QueryString")])') = 1 OR
								Attendance.ContactPerson.exist('(/Person[Name=sql:variable("@QueryString")])') = 1)
								--)
							ORDER BY Attendance.[DateTime] DESC
							FOR XML PATH('Register'), TYPE)
						FOR XML PATH('Attendance'), TYPE)
	
	IF @@ROWCOUNT = 0
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="0">Nenhum registro encontrado</Error></Message>' AS XML)
	END
	
	RETURN 1				

END











