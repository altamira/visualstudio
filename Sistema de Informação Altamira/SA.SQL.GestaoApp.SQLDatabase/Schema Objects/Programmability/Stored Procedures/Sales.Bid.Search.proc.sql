CREATE PROCEDURE [Sales].[Bid.Search]
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
		NOT (PATINDEX('%Bid Register%', @Session.value('(/Session/User/Rules)[1]', 'nvarchar(max)')) > 0 OR 
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
	SET @QueryString = '%' + @xmlRequest.value('(/Query)[1]', 'VARCHAR(max)') + '%'
	
	SET @xmlResponse =	(SELECT 
							(SELECT /*TOP 100*/ Bid.Id AS '@Id',
								Bid.[DateTime] AS 'DateTime', 
								LTRIM(RTRIM(Bid.Number)) AS 'Number',
								LTRIM(RTRIM(orc.[orclst_revisao])) AS 'Revision',
								(SELECT 
									(SELECT 
										CASE 
											WHEN NOT st.st_codigo IS NULL THEN st.st_codigo
											WHEN orc.[orclst_numero] IS NULL AND EXISTS(SELECT * FROM WBCCAD.dbo.ORCCAB cab WHERE cab.numeroOrcamento = Bid.Number) THEN '5' 
											ELSE 0 END AS '@Id', 
										CASE 
											WHEN NOT st.st_codigo IS NULL THEN orcsit.ORCALTDTH
											ELSE Bid.[DateTime] END AS '@DateTime',
										CASE 
											WHEN NOT st.st_descricao IS NULL THEN st.st_descricao
											WHEN orc.[orclst_numero] IS NULL AND EXISTS(SELECT * FROM WBCCAD.dbo.ORCCAB cab WHERE cab.numeroOrcamento = Bid.Number) THEN '1.1 Em Liberação'
											ELSE '1.1 Em Liberação' END AS 'text()' FOR XML PATH('Status'), TYPE),
										(SELECT 
											h.orchist_historico AS 'text()' 
										FROM WBCCAD.dbo.OrcHist h 
										WHERE h.numeroOrcamento =  
											CASE WHEN orc.[orclst_revisao] IS NULL OR LEN(LTRIM(RTRIM(orc.[orclst_revisao]))) = 0
												THEN orc.[orclst_numero] ELSE LTRIM(RTRIM(orc.[orclst_numero])) + LTRIM(RTRIM(orc.[orclst_revisao])) END
										FOR XML PATH('Comments'), TYPE)
									FOR XML PATH('WBCCAD'), TYPE),
								(SELECT Client.Id as '@Id',
										LTRIM(RTRIM(Client.CodeName)) AS 'CodeName',
										Client.ContactPerson, 
										Client.LocationAddress,
										(SELECT 
											Vendor.Id AS '@Id', 
											Vendor.Name AS 'text()'
										FROM Sales.Vendor Vendor
										WHERE Vendor.ID = Client.[Sales.Vendor.Id]
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
										PurchaseType.Id AS '@Id',
										PurchaseType.[Description] AS 'text()'
								FROM Sales.PurchaseType PurchaseType
								WHERE PurchaseType.Id = [Sales.PurchaseType.Id]
								FOR XML PATH('PurchaseType'), TYPE),  
								Bid.ContactPerson, 
								Bid.ContactPersonCopyTo,
								Bid.LocationAddress, 
								Bid.Comments,
								(SELECT 
									(SELECT TOP 50 
											[FileName] AS 'Name',
											[Length] AS 'Length',
											[Create] AS 'Create',
											[LastUpdate] AS 'LastUpdate'
									FROM dbo.DirectoryList( 
										Sales.[Bid.Document.Path](), 
										CAST(CAST(Bid.Number AS INT) AS NVARCHAR(50)) + '*.pdf', 
										0)
									FOR XML PATH('Document'), TYPE)
								FOR XML PATH('Documents'), TYPE),
								(SELECT 
									(SELECT TOP 50 
											[FileName] AS 'Name',
											[Length] AS 'Length',
											[Create] AS 'Create',
											[LastUpdate] AS 'LastUpdate'
									FROM dbo.DirectoryList( 
										Sales.[Bid.Project.Path](), 
										CAST(CAST(Bid.Number AS INT) AS NVARCHAR(50)) + '*.pdf', 
										0)
									FOR XML PATH('Document'), TYPE)
								FOR XML PATH('Projects'), TYPE),
								(SELECT 
									(SELECT 
										--ORCPRD.ORCITM AS 'Item', 
										LEFT(ORCPRD.PRDCOD, 20) AS 'Code',
										MIN(ORCPRD.PRDDSC) AS 'Description',
										ORCPRD.CORCOD AS 'Color',  
										SUM(CAST(ORCPRD.ORCQTD AS INT)) AS 'Quantity',	
										SUM(CAST(ORCPRD.ORCPES AS DECIMAL(10,2))) AS 'Weight' 
									FROM WBCCAD.dbo.INTEGRACAO_ORCPRD ORCPRD
									WHERE ORCPRD.GRPCOD > 0 AND ORCPRD.ORCNUM = LTRIM(RTRIM(Bid.Number))
									GROUP BY ORCPRD.ORCNUM, ORCPRD.ORCITM, LEFT(ORCPRD.PRDCOD, 20),ORCPRD.CORCOD 
									FOR XML PATH('Item'), TYPE)
								FOR XML PATH('Items'), TYPE),
								/*(SELECT 
									(SELECT Rev.Id AS '@Id',
										orccab.[orccab_Cadastro] AS 'DateTime', 
										orccab.[numeroOrcamento] AS 'Number',
										orccab.[orccab_revisao] AS 'Revision',
										(SELECT 
											(SELECT 
												CASE 
													WHEN NOT revst.st_codigo IS NULL THEN revst.st_codigo
													--WHEN orccab.[numeroOrcamento] IS NULL AND EXISTS(SELECT * FROM WBCCAD.dbo.ORCCAB revcab WHERE revcab.numeroOrcamento = Rev.Number) THEN '5' 
													ELSE 0 END AS '@Id', 
												CASE 
													WHEN NOT revst.st_codigo IS NULL THEN orccab.[orccab_Data_Status]
													ELSE GETDATE() END AS '@DateTime',
												CASE 
													WHEN NOT revst.st_descricao IS NULL THEN revst.st_descricao
													--WHEN orccab.[numeroOrcamento] IS NULL AND EXISTS(SELECT * FROM WBCCAD.dbo.ORCCAB revcab WHERE revcab.numeroOrcamento = orccab.[numeroOrcamento]) THEN '1.1 Em Liberação'
													ELSE '1.1 Em Liberação' END AS 'text()' FOR XML PATH('Status'), TYPE),
												revh.orchist_historico AS 'Comments' FOR XML PATH('WBCCAD'), TYPE),
										(SELECT RevClient.Id as '@Id',
												LTRIM(RTRIM(RevClient.CodeName)) AS 'CodeName',
												RevClient.ContactPerson, 
												RevClient.LocationAddress,
												(SELECT 
													RevVendor.Id AS '@Id', 
													RevVendor.Name AS 'text()'
												FROM Sales.Vendor RevVendor
												WHERE RevVendor.ID = RevClient.[Sales.Vendor.Id]
												FOR XML PATH('Vendor'), TYPE), 
												(SELECT 
													RevMedia.Id AS '@Id', 
													RevMedia.[Description] AS 'text()'
												FROM Contact.Media RevMedia
												WHERE RevMedia.Id = RevClient.[Contact.Media.Id]
												FOR XML PATH('Media'), TYPE)
										FOR XML PATH('Client'), TYPE),
										(SELECT RevVendor.Id as '@Id',
												RevVendor.Name AS 'text()' 
										FOR XML PATH('Vendor'), TYPE),
										(SELECT 
												RevPurchaseType.Id AS '@Id',
												RevPurchaseType.[Description] AS 'text()'
										FROM Sales.PurchaseType RevPurchaseType
										WHERE RevPurchaseType.Id = [Sales.PurchaseType.Id]
										FOR XML PATH('PurchaseType'), TYPE),  
										Rev.ContactPerson, 
										Rev.ContactPersonCopyTo,
										Rev.LocationAddress, 
										Rev.Comments
									FROM Sales.Bid Rev
									INNER JOIN Sales.Client RevClient ON Rev.[Sales.Client.Id] = RevClient.Id
									INNER JOIN Sales.Vendor RevVendor ON Rev.[Sales.Vendor.Id] = RevVendor.Id
									INNER JOIN WBCCAD.dbo.ORCCAB orccab ON orccab.[numeroOrcamento] LIKE LTRIM(RTRIM(Rev.Number)) + '%'
									LEFT JOIN WBCCAD.dbo.Orcst revst ON (orccab.[orccab_Status] = revst.st_codigo OR (orccab.[orccab_Status] = st.st_codigo + 1 AND orccab.[orccab_Status] > 10)) 
									LEFT JOIN WBCCAD.dbo.OrcHist revh ON revh.numeroOrcamento = orccab.[numeroOrcamento]
									WHERE Rev.Number = Bid.Number AND orccab.[numeroOrcamento] <> LTRIM(RTRIM(orc.[orclst_numero])) + LTRIM(RTRIM(orc.[orclst_revisao]))
									ORDER BY Bid.Number DESC
									FOR XML PATH('Register'), TYPE)	
								FOR XML PATH('Revisions'), TYPE)	*/		
								(SELECT [Order].LPPED AS '@Number',
									[Order].LPENT AS 'DateTime',
									(SELECT TOP 1
											[Order.Client].CCPc0Cod AS '@Id',
											[Order.Client].CCCGC AS 'Code', 
											LTRIM(RTRIM([Order.Client].CCNOM)) AS 'Name'
									FROM GPIMAC_Altamira.dbo.CaCLI [Order.Client]
									WHERE [Order.Client].CCCGC = [Order].CCCGC
									FOR XML PATH('Client'), TYPE),
									(SELECT 
										(SELECT 
											Items.[CPROCOD] AS 'Code',
											Items.[Lp1DesDet] AS 'Description',
											Items.[CCorCod] AS 'Color',
											Items.[LPQUA] AS 'Quantity',
											0 AS 'Weight',
											Items.[LPPRE] AS 'Price'
										FOR XML PATH('Item'), TYPE)
									FROM [GPIMAC_Altamira].[dbo].[LPV1] Items
									WHERE Items.LPPED = [Order].LPPED
									FOR XML PATH('Items'), TYPE)
									FROM GPIMAC_Altamira.dbo.LPV [Order]
									WHERE [Order].LPWBCCADORCNUM = Bid.Number
								FOR XML PATH('Order'), TYPE)
							FROM Sales.Bid Bid
							INNER JOIN Sales.Client Client ON Bid.[Sales.Client.Id] = Client.Id
							INNER JOIN Sales.Vendor Vendor ON Bid.[Sales.Vendor.Id]	= Vendor.Id
							LEFT JOIN WBCCAD.dbo.Orclst orc ON orc.[orclst_numero] = Bid.Number
							LEFT JOIN WBCCAD.dbo.INTEGRACAO_ORCSIT orcsit ON orcsit.ORCNUM = Bid.Number
							LEFT JOIN WBCCAD.dbo.Orcst st ON (orc.[orclst_status] = st.st_codigo OR (orc.[orclst_status] = st.st_codigo + 1 AND orc.[orclst_status] > 10)) 
							WHERE 
							((@QueryString = '%%' AND NOT @StartDate IS NULL AND NOT @EndDate IS NULL) AND 
								(Bid.[DateTime] BETWEEN @StartDate AND @EndDate))
							OR (@QueryString <> '%%' AND 
								(Bid.Number LIKE @QueryString
								OR st.st_descricao LIKE @QueryString
								OR Client.CodeName LIKE @QueryString
								OR Vendor.Name LIKE @QueryString))
							ORDER BY Bid.Number DESC
							FOR XML PATH('Register'), TYPE)
						FOR XML PATH('Bid'), TYPE)
	RETURN 1				

END



