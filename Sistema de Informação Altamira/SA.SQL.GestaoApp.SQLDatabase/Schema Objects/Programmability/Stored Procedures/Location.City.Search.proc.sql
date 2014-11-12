CREATE PROCEDURE [Location].[City.Search]
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @QueryString NVARCHAR(MAX)
	
	SET @QueryString = '%' + @xmlRequest.value('(/querystring)[1]', 'VARCHAR(max)') + '%'
	
	SET @xmlResponse =	(SELECT 
							(SELECT TOP 30 Location.City.Id AS '@Id', Location.City.Name AS '@Name', 
								   (SELECT Location.[State].Id AS '@Id', Location.[State].Name AS '@Name', Location.State.Acronym AS '@Acronym' FOR XML PATH('State'), TYPE)
							FROM Location.City 
							INNER JOIN Location.[State] ON Location.City.[Location.State.Id] = Location.[State].Id
							WHERE city.Name LIKE @QueryString
							FOR XML PATH('City'), TYPE)
						FOR XML PATH('Cities'), TYPE)
	RETURN 1				

END











