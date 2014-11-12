CREATE PROCEDURE [Sales].[Client.Search]
	@Guid AS UNIQUEIDENTIFIER,
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @QueryString NVARCHAR(MAX)
	
	SET @QueryString = '%' + @xmlRequest.value('(/querystring)[1]', 'VARCHAR(max)') + '%'
	
	SET @xmlResponse =	(SELECT 
							(SELECT Client.Id as '@Id',
									Client.CodeName, 
									Client.ContactPerson, 
									Client.LocationAddress, 
									(SELECT 
										Vendor.Id AS '@Id', 
										Vendor.Name
									FOR XML PATH('Vendor'), TYPE),
									(SELECT 
										Media.Id AS '@Id',
										Media.[Description]
									FOR XML PATH('Media'), TYPE)
							FROM Sales.Client Client
							INNER JOIN Sales.Vendor Vendor ON Vendor.Id = Client.[Sales.Vendor.Id] 
							INNER JOIN Contact.Media Media ON Media.Id = Client.[Contact.Media.Id]
							WHERE 
								@QueryString <> '%%' AND 
								Client.CodeName LIKE @QueryString
							ORDER BY Client.CodeName
							FOR XML PATH('Client'), TYPE)
						FOR XML PATH('Clients'), TYPE)
	IF @@ROWCOUNT = 0
	BEGIN
		SET @xmlResponse = CAST('<Message Id="0">Nenhum Cliente encontrado !</Message>' AS XML)
	END
	
	RETURN 1				

END











