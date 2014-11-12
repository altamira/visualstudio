-- =============================================
-- Script Template
-- =============================================

/*
SELECT 'INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (' +
		CAST(V.Id AS NVARCHAR(10)) + ', ''' + 
		CAST(LTRIM(RTRIM(V.Code)) AS NVARCHAR(10)) + ''', ''' + 
		CAST(LTRIM(RTRIM(V.Name)) AS NVARCHAR(MAX)) + ''',' + CHAR(13) +
		' CAST(''' +
		CASE 
		WHEN NOT V.Prefix IS NULL AND NOT V.Number IS NULL AND  
			LEN(LTRIM(RTRIM(V.Prefix))) > 0 AND LEN(LTRIM(RTRIM(V.Number))) > 0 THEN 
			'<Fone>' +
				'<AreaCode>' + V.AreaCode + '</AreaCode>' +
				'<Prefix>' + V.Prefix + '</Prefix>' +
				'<Number>' + V.Number + '</Number>' +
				--'<AccessCode>' + V.AccessCode + '</AccessCode>' +
				'<FoneType Id="4">Celular</FoneType>' +
				'<Country Id="1">Brasil</Country>' +
			'</Fone>' 
		ELSE '' END + ''' AS XML), CAST(''' +
		CASE 
		WHEN NOT V.Email IS NULL AND LEN(LTRIM(RTRIM(V.Email))) > 0 THEN 
			'<Email>' +
				'<Address>' + V.Email + '</Address>' +
			'</Email>'
		ELSE '' END + ''' AS XML))' + CHAR(13) + 'GO' + CHAR(13)
FROM Gestao.Sales.Vendor V
*/

PRINT 'Inserting [Sales].[Vendor]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Sales].[Vendor] ON

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (1, '001', 'Administração',
 CAST('' AS XML), CAST('<Email><Address>gerencia.vendas@altamira.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (2, '003', 'Celso',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>7815</Prefix><Number>3591</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>logserv@terra.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (3, '004', 'Luiz Barbi',
 CAST('<Fone><AreaCode>21</AreaCode><Prefix>7815</Prefix><Number>9788</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>luisbarbi@globo.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (4, '005', 'Carlos Lippi',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>7838</Prefix><Number>2264</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>clippipavesi@gmail.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (5, '006', 'Edson',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>7838</Prefix><Number>2258</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>edson@altamira.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (6, '008', 'Clayton',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>7729</Prefix><Number>9356</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>capelatto@altamira.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (7, '009', 'Marcilio - Tolentino',
 CAST('<Fone><AreaCode>81</AreaCode><Prefix>9232</Prefix><Number>0300</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>vendas@tolentino.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (8, '010', 'Paulo Jorge',
 CAST('<Fone><AreaCode>21</AreaCode><Prefix>7815</Prefix><Number>9785</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>pjfontes@globo.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (9, '012', 'Luiz Augusto',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>7838</Prefix><Number>2251</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>luiz.augusto9@gmail.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (11, '042', 'Elthon',
 CAST('<Fone><AreaCode>92</AreaCode><Prefix>9974</Prefix><Number>7370</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>elthon.saraiva@equipamanaus.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (12, '043', 'Neto',
 CAST('<Fone><AreaCode>31</AreaCode><Prefix>9261</Prefix><Number>4231</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>vendas.neto@gmail.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (13, '045', 'Fernando Biotins',
 CAST('' AS XML), CAST('<Email><Address>biotinsbsolucoes@uol.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (14, '046', 'Nicole',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>8315</Prefix><Number>7215</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>nicoleamboni@yahoo.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (15, '047', 'Luiz Neves',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>9113</Prefix><Number>5575</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>montarim@montarim.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (16, '048', 'Phelipe Campos',
 CAST('<Fone><AreaCode>19</AreaCode><Prefix>7807</Prefix><Number>5530</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>phelipe.campos@altamira.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (17, '049', 'Bruno Araujo',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>7876</Prefix><Number>9559</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>bruno@altamira.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (18, '053', 'Luis Belloli',
 CAST('<Fone><AreaCode>51</AreaCode><Prefix>9986</Prefix><Number>2204</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>luis.belloli@ibest.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (19, '099', 'Alessandro (Teste)',
 CAST('<Fone><AreaCode>11</AreaCode><Prefix>8442</Prefix><Number>0440</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>alessandrohmachado@gmail.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (20, '016', 'Gondola - Josne',
 CAST('' AS XML), CAST('' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (21, '040', 'Durval (Administração)',
 CAST('' AS XML), CAST('' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (22, '044', 'Mota (Administração)',
 CAST('' AS XML), CAST('' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (23, '117', 'Paulo da PJ (Administração)',
 CAST('' AS XML), CAST('' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (24, '050', 'Retec Brasil',
 CAST('' AS XML), CAST('<Email><Address>rbraga@retecbrasil.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (25, '118', 'P. LEAL & R SOUZA ME (PEDRO/RICARDO)',
 CAST('<Fone><AreaCode>43</AreaCode><Prefix>3336</Prefix><Number>8782</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>comercial.cmh@gmail.com</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (26, '041', 'PAULO ROBERTO SIMÕES DE SIMÕES',
 CAST('<Fone><AreaCode>27</AreaCode><Prefix>8801</Prefix><Number>4228</Number><FoneType Id="4">Celular</FoneType><Country Id="1">Brasil</Country></Fone>' AS XML), CAST('<Email><Address>ssimoes@consumeta.com.br</Address></Email>' AS XML))
GO

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail]) VALUES (27, '119', 'Comercial V N',
 CAST('' AS XML), CAST('' AS XML))
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Sales].[Vendor] OFF

INSERT INTO Sales.Vendor ([Code], [Name])
SELECT [verp_Codigo], [verp_RazaoSocial] 
FROM DBALTAMIRA.dbo.VE_Representantes 
WHERE NOT EXISTS (SELECT * FROM Sales.Vendor WHERE verp_Codigo = Code)

/*
DELETE FROM Sales.Vendor
GO

SET NOCOUNT ON
SET IDENTITY_INSERT [Sales].[Vendor] ON
GO

UPDATE Gestao.Sales.Vendor SET AreaCode = '' WHERE AreaCode IS NULL
UPDATE Gestao.Sales.Vendor SET Prefix = '' WHERE Prefix IS NULL
UPDATE Gestao.Sales.Vendor SET Number = '' WHERE Number IS NULL
UPDATE Gestao.Sales.Vendor SET AccessCode = '' WHERE AccessCode IS NULL

INSERT INTO Sales.Vendor ([Id], [Code], [Name], [ContactFone], [ContactEmail])
SELECT  V.Id, 
		V.Code, 
		V.Name,
		CASE 
		WHEN NOT V.Prefix IS NULL AND NOT V.Number IS NULL AND  
			LEN(LTRIM(RTRIM(V.Prefix))) > 0 AND LEN(LTRIM(RTRIM(V.Number))) > 0 THEN 
			CAST('<Fone>' +
					'<AreaCode>' + V.AreaCode + '</AreaCode>' +
					'<Prefix>' + V.Prefix + '</Prefix>' +
					'<Number>' + V.Number + '</Number>' +
					--'<AccessCode>' + V.AccessCode + '</AccessCode>' +
					'<FoneType Id="4">Celular</FoneType>' +
					'<Country Id="1">Brasil</Country>' +
				 '</Fone>' AS XML) 
		ELSE CAST('' AS XML) END,
		CASE 
		WHEN NOT V.Email IS NULL AND LEN(LTRIM(RTRIM(V.Email))) > 0 THEN 
			CAST('<Email>' +
				  '<Address>' + V.Email + '</Address>' +
				  '</Email>' AS XML)
		ELSE CAST('' AS XML) END
FROM Gestao.Sales.Vendor V


SET IDENTITY_INSERT [Sales].[Vendor] OFF
GO
*/

/*
SELECT V.*, G.*
  FROM [Gestao].[Sales].[Vendor] G
  INNER JOIN Sales.Vendor V ON G.Code = V.Code
*/
