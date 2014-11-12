CREATE PROCEDURE [Sales].[Dashboard]	
	@SessionGuid AS UNIQUEIDENTIFIER,
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Return INT
	DECLARE @Session XML

	EXEC @Return = Security.[Session.Validate] @SessionGuid, NULL, @Session OUTPUT
	
	IF @Return <> 1
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado !</Error></Message>' AS XML)
		RETURN 0
	END
	
	IF	@Session IS NULL OR
		@Session.exist('(/Session)[1]') <> 1 OR
		NOT (PATINDEX('%Sales Dashboard%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
		LTRIM(RTRIM(@Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)'))) = '*')
	BEGIN
		SET @xmlResponse = CAST('<Message><Error Id="9999">Acesso negado !</Error></Message>' AS XML)
		RETURN 0
	END
	
	DECLARE @StartDate AS DATETIME
	DECLARE @EndDate AS DATETIME

	SET @StartDate = @xmlRequest.value('(/Dashboard/StartDate/text())[1]', 'DATETIME')
	SET @EndDate = @xmlRequest.value('(/Dashboard/EndDate/text())[1]', 'DATETIME')
	
	SET @xmlResponse = (SELECT 
							(SELECT  
								(SELECT CAST(orc.[orclst_cadastro] AS Date) '@Date', 
								COUNT(*) AS '@Quantity', 
								SUM(CASE WHEN orc.[orclst_total] IS NULL THEN 0 ELSE orc.[orclst_total] END) AS '@Value'
								FROM WBCCAD.dbo.orclst orc
								INNER JOIN WBCCAD.dbo.ORCST st ON orc.[orclst_status] = st.st_codigo 
								WHERE orc.[orclst_cadastro] > DATEADD(d, DATEPART(dd, DATEADD(mm, -12, getdate())) * -1, DATEADD(mm, -12, getdate()))
								AND LEFT(orc.[orclst_numero], 4) <> '0000'  
								GROUP BY CAST(orc.[orclst_cadastro] AS Date)
								ORDER BY CAST(orc.[orclst_cadastro] AS Date) desc
								FOR XML PATH('Day'), TYPE)
							FOR XML PATH('Days'), TYPE),
							(SELECT
								(SELECT st.st_codigo as '@Code', 
								MIN(st.st_descricao) as '@Description', 
								COUNT(*) AS '@Quantity', 
								SUM(CASE WHEN orc.[orclst_total] IS NULL THEN 0 ELSE orc.[orclst_total] END) AS '@Value'
								FROM WBCCAD.dbo.orclst orc
								INNER JOIN WBCCAD.dbo.Orcst st ON orc.[orclst_status] = st.st_codigo 
								WHERE NOT orc.[orclst_cadastro] IS NULL AND LEFT(orc.[orclst_numero], 4) <> '0000'
								AND orc.[orclst_cadastro] BETWEEN @StartDate AND @EndDate
								GROUP BY st.st_codigo
								ORDER BY st.st_codigo
								FOR XML PATH('Status'), TYPE)
							FOR XML PATH('Bid'), TYPE),
							(SELECT
								(SELECT Vendor.Name as '@Name', 
								COUNT(*) AS '@Quantity', 
								SUM(CASE WHEN orclst.[orclst_total] IS NULL THEN 0 ELSE orclst.[orclst_total] END) AS '@Value'
								FROM Sales.Vendor Vendor
								INNER JOIN WBCCAD.dbo.orclst orclst ON Vendor.Code = orclst.[ORCLST_VENDEDOR] 
								WHERE NOT orclst.[orclst_cadastro] IS NULL AND LEFT(orclst.[orclst_numero], 4) <> '0000'
								AND orclst.[orclst_cadastro] BETWEEN @StartDate AND @EndDate
								GROUP BY Vendor.Name
								ORDER BY Vendor.Name
								FOR XML PATH('Vendor'), TYPE)
							FOR XML PATH('Vendors'), TYPE)						
						FOR XML PATH('Dashboard'), TYPE)

END








