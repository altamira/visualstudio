CREATE PROCEDURE [Sales].[Vendor.Search]
	@Guid AS UNIQUEIDENTIFIER,
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @QueryString NVARCHAR(MAX)
	
	SET @QueryString = '%' + @xmlRequest.value('(/querystring)[1]', 'VARCHAR(max)') + '%'
	
	SET @xmlResponse =	(SELECT 
							(SELECT Id as '@Id',
									Code, Name, ContactFone, ContactEmail
							FROM Sales.Vendor
							WHERE Code LIKE @QueryString OR Name LIKE @QueryString
							ORDER BY Code, Name
							FOR XML PATH('Vendor'), TYPE)
						FOR XML PATH('Vendors'), TYPE)
	RETURN 1				

END











