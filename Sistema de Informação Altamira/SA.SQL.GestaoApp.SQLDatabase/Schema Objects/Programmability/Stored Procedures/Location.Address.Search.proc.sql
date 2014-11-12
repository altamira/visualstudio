CREATE PROCEDURE [Location].[Address.Search]
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @QueryString NVARCHAR(MAX)
	
	SET @QueryString = @xmlRequest.value('(/querystring)[1]', 'VARCHAR(max)') + '%'

    -- Insert statements for procedure here
    SET @xmlResponse =	(SELECT  
							(SELECT TOP 30 [LOG].LOG_NOME AS '@n', B.BAI_NO AS '@b', L.LOC_NO AS '@c', LEFT(Correios.dbo.GetCEP([LOG].[LOG_KEY_DNE]), 5) + '-' + RIGHT(Correios.dbo.GetCEP([LOG].[LOG_KEY_DNE]), 3) AS '@p'
							FROM [Correios].[dbo].[LOG_LOGRADOURO] [LOG],
							[Correios].[dbo].[LOG_BAIRRO] B,
							[Correios].[dbo].LOG_LOCALIDADE L
							WHERE [BAI_NU_SEQUENCIAL_INI] = B.BAI_NU_SEQUENCIAL 
							AND B.LOC_NU_SEQUENCIAL = L.LOC_NU_SEQUENCIAL
							AND LOG_NOME LIKE @QueryString 
							AND L.LOC_IN_TIPO_LOCALIDADE = 'M'
							FOR XML PATH('l'), TYPE)
						FOR XML PATH('logradouro'), TYPE)
	RETURN 1
END












