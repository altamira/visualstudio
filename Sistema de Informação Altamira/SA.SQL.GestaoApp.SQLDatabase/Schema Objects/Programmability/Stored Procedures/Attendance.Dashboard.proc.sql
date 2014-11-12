CREATE PROCEDURE [Attendance].[Dashboard]	
	@SessionGuid UNIQUEIDENTIFIER,
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
		NOT (PATINDEX('%Attendance Dashboard%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
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
								(SELECT CAST(Attendance.[DateTime] AS Date) '@Date', 
								COUNT(*) AS '@y',
								SUM(CASE 
										WHEN 
											LTRIM(RTRIM([Type].[Description])) = 'ATENDIMENTO AO CLIENTE' OR	
											LTRIM(RTRIM([Type].[Description])) = 'Solicitação de visitas' OR 
											LTRIM(RTRIM([Type].[Description])) = 'Solicitação de orçamentos' 
										THEN 1 ELSE 0 END) AS '@x1',
								SUM(CASE WHEN LTRIM(RTRIM([Type].[Description])) = 'MUDANÇA DE PROJETO/ORÇAMENTO' THEN 1 ELSE 0 END) AS '@x2',
								SUM(CASE WHEN LTRIM(RTRIM([Type].[Description])) = 'NEGOCIAÇÃO' THEN 1 ELSE 0 END) AS '@x3',
								SUM(CASE WHEN LTRIM(RTRIM([Type].[Description])) = 'RECLAMAÇÃO DO REPRESENTANTE' THEN 1 ELSE 0 END) AS '@x4'
								FROM Attendance.Register AS Attendance
								INNER JOIN Attendance.[Type] AS [Type] ON Attendance.[Attendance.Type.Id] = [Type].Id
								WHERE Attendance.[DateTime] >= DATEADD(d, DATEPART(dd, DATEADD(mm, -12, getdate())) * -1, DATEADD(mm, -12, getdate()))
								GROUP BY CAST(Attendance.[DateTime] AS Date)
								ORDER BY CAST(Attendance.[DateTime] AS Date) DESC
								FOR XML PATH('Day'), TYPE)
							FOR XML PATH('Days'), TYPE),
							(SELECT 
								(SELECT CAST(Attendance.[DateTime] AS Date) '@Date', 
								COUNT(*) AS '@y',
								SUM(CASE 
										WHEN
											LTRIM(RTRIM([Type].[Description])) = 'ATENDIMENTO AO CLIENTE' OR 
											LTRIM(RTRIM([Type].[Description])) = 'Solicitação de visitas' OR 
											LTRIM(RTRIM([Type].[Description])) = 'Solicitação de orçamentos' 
										THEN 1 ELSE 0 END) AS '@x1',
								SUM(CASE WHEN LTRIM(RTRIM([Type].[Description])) = 'MUDANÇA DE PROJETO/ORÇAMENTO' THEN 1 ELSE 0 END) AS '@x2',
								SUM(CASE WHEN LTRIM(RTRIM([Type].[Description])) = 'NEGOCIAÇÃO' THEN 1 ELSE 0 END) AS '@x3',
								SUM(CASE WHEN LTRIM(RTRIM([Type].[Description])) = 'RECLAMAÇÃO DO REPRESENTANTE' THEN 1 ELSE 0 END) AS '@x4'
								FROM Attendance.Register AS Attendance
								INNER JOIN Attendance.[Type] AS [Type] ON Attendance.[Attendance.Type.Id] = [Type].Id
								WHERE Attendance.[DateTime] BETWEEN @StartDate AND @EndDate
								GROUP BY CAST(Attendance.[DateTime] AS Date)
								ORDER BY CAST(Attendance.[DateTime] AS Date) DESC
								FOR XML PATH('Type'), TYPE)
							FOR XML PATH('Types'), TYPE),
							(SELECT 
								(SELECT COUNT(*) AS '@y', name as '@x'
								FROM Attendance.Register AS Attendance
								INNER JOIN Sales.Vendor AS Vendor
								ON Attendance.[Sales.Vendor.Id] = Vendor.Id
								WHERE Attendance.[DateTime] BETWEEN @StartDate AND @EndDate
								GROUP BY Vendor.Name
								ORDER BY Vendor.Name
								FOR XML PATH('Vendor'), TYPE)
							FOR XML PATH('Vendors'), TYPE),
							(SELECT
								(SELECT Media.[Description] as '@x', 
								COUNT(*) AS '@y'
								FROM Attendance.Register AS Attendance
								INNER JOIN Sales.Client AS Client ON Attendance.[Sales.Client.Id] = Client.Id
								INNER JOIN Contact.Media Media ON Client.[Contact.Media.Id] = Media.Id
								WHERE Attendance.[DateTime] BETWEEN @StartDate AND @EndDate
								GROUP BY Media.[Description]
								ORDER BY Media.[Description]
								FOR XML PATH('Origin'), TYPE)
							FOR XML PATH('Origins'), TYPE)						
						FOR XML PATH('Dashboard'), TYPE)

END












