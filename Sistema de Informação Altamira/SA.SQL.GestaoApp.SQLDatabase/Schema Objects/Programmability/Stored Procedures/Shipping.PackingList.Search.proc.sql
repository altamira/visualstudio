CREATE PROCEDURE [Shipping].[PackingList.Search]
	@Guid AS UNIQUEIDENTIFIER,
	@xmlRequest AS XML,
	@xmlResponse AS XML OUTPUT
AS
BEGIN

	SET NOCOUNT ON
	
	SET @xmlResponse = CAST('<Message><Error Id="99">Acesso negado.</Error></Message>' AS XML)
	RETURN 0
	
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @QueryString NVARCHAR(MAX)

	SET @StartDate = @xmlRequest.value('(/Query/@StartDate)[1]', 'DATETIME')	
	SET @EndDate = @xmlRequest.value('(/Query/@EndDate)[1]', 'DATETIME')	
	SET @QueryString = '%' + @xmlRequest.value('(/Query)[1]', 'VARCHAR(max)') + '%'

	SET @xmlResponse =	(SELECT 
							(SELECT 
								(SELECT ORCSIT.ORCNUM AS 'Number',
									(SELECT 0 as '@Id',
											MIN(ORCCAB.CLINOM) AS Name 
									FOR XML PATH('Client'), TYPE)
								FOR XML PATH('Bid.Register'), TYPE),
								(SELECT LPV.LPPED AS 'Number',
									(SELECT TOP 1
											CACLI.CCPc0Cod AS '@Id',
											CACLI.CCCGC AS 'Code', 
											LTRIM(RTRIM(CACLI.CCNOM)) AS 'Name'
									FROM GPIMAC_Altamira.dbo.CaCLI CACLI
									WHERE CACLI.CCCGC = MIN(LPV.CCCGC)
									FOR XML PATH('Client'), TYPE)
								FOR XML PATH('Order'), TYPE),
								(SELECT 
									(SELECT 
										ORCPRD.ORCITM AS '@Item', 
										LEFT(ORCPRD.PRDCOD, 20) AS 'Code',
										MIN(ORCPRD.PRDDSC) AS 'Description',
										ORCPRD.CORCOD AS 'Color',  
										SUM(CAST(ORCPRD.ORCQTD AS INT)) AS 'Quantity',	
										SUM(CAST(ORCPRD.ORCPES AS DECIMAL(10,2))) AS 'Weight' 
									FROM WBCCAD.dbo.INTEGRACAO_ORCPRD ORCPRD
									WHERE GRPCOD > 0 AND ORCPRD.ORCNUM = ORCSIT.ORCNUM
									GROUP BY ORCPRD.ORCNUM, ORCPRD.ORCITM, LEFT(ORCPRD.PRDCOD, 20),ORCPRD.CORCOD 
									FOR XML PATH('Material'), TYPE)
								FOR XML PATH('Items'), TYPE)
							FROM WBCCAD.dbo.INTEGRACAO_ORCSIT ORCSIT
							INNER JOIN WBCCAD.dbo.INTEGRACAO_ORCCAB ORCCAB
							ON ORCSIT.ORCNUM = ORCCAB.ORCNUM
							INNER JOIN GPIMAC_Altamira.dbo.LPV LPV
							ON LPV.LPWBCCADORCNUM = ORCSIT.ORCNUM
							WHERE ORCCAB.CLINOM LIKE @QueryString
							AND ORCCAB.ORCALTDTH BETWEEN @StartDate AND @EndDate
							GROUP BY ORCSIT.ORCNUM, LPV.LPPED
							FOR XML PATH('PackingList'), TYPE)
						FOR XML PATH('Shipping'), TYPE)
	
	RETURN 1				

END











