










--DROP TABLE LAORVAUX



CREATE VIEW [dbo].[View_LaOrvAgrupadoWBCCAD]
AS

SELECT 
	'01' AS Empresa,
	Bid.Number AS Número,
	'' AS Revisão,
	0 AS [Codigo da Situação],
	'WBCCAD' AS Origem,
	Bid.[DateTime] AS [Data do Cadastro],
	CONVERT(NVARCHAR(10), DATEADD(dd, 10, Bid.[DateTime]), 103) AS [Data de Validade], 
	'MASTER' AS [Nome do Usuário],
	[Sales.Client.Id] AS Cliente,
	Client.CodeName AS [Nome Fantasia],
	Client.CodeName AS [Razão Social],
	'R' AS Logradouro,
	Bid.LocationAddress.value('(/Address/Street/text())[1]', 'NVARCHAR(200)') AS Endereço,
	Bid.LocationAddress.value('(/Address/Number/text())[1]', 'CHAR(10)') AS [Número do Endereço],
	Bid.LocationAddress.value('(/Address/Complement/text())[1]', 'CHAR(30)') AS [Complemento do Endereço],
	Bid.LocationAddress.value('(/Address/District/text())[1]', 'CHAR(200)') AS Bairro,
	Bid.LocationAddress.value('(/Address/PostalCode/text())[1]', 'CHAR(9)') AS CEP,
	Bid.LocationAddress.value('(/Address/City/text())[1]', 'CHAR(200)') AS Cidade,
	(SELECT Acronym FROM GESTAOAPP.Location.City INNER JOIN GESTAOAPP.Location.[State] ON City.[Location.State.Id] = [State].Id WHERE City.Id = Bid.LocationAddress.value('(/Address/City/@Id)[1]', 'INT')) AS Estado,
	Client.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode/text())[1]', 'CHAR(3)') AS [DDD do Telefone],
	Client.ContactPerson.value('(/Person/ContactFone/Fone/Prefix/text())[1]', 'CHAR(4)') + '-' +
	Client.ContactPerson.value('(/Person/ContactFone/Fone/Number/text())[1]', 'CHAR(4)') AS [Telefone],
	Client.ContactPerson.value('(/Person/ContactFone/Fone/AccessCode/text())[1]', 'CHAR(5)') AS [Ramal do Telefone],
	Client.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode/text())[1]', 'CHAR(3)') AS [DDD do Fax],
	Client.ContactPerson.value('(/Person/ContactFone/Fone/Prefix/text())[1]', 'CHAR(4)') + '-' +
	Client.ContactPerson.value('(/Person/ContactFone/Fone/Number/text())[1]', 'CHAR(4)') AS [Fax],
	Client.ContactPerson.value('(/Person/ContactFone/Fone/AccessCode/text())[1]', 'CHAR(5)') AS [Ramal do Fax],
	0 AS [ID do Contato],
	Bid.ContactPerson.value('(/Person/Name/text())[1]', 'CHAR(200)') AS [Nome do Contato],
	Bid.ContactPerson.value('(/Person/Department/text())[1]', 'CHAR(100)') AS [Departamento do Contato],
	'' AS [Cargo do Contato],
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode/text())[1]', 'CHAR(3)') AS [DDD do Telefone do Contato],
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix/text())[1]', 'CHAR(4)') + '-' +
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number/text())[1]', 'CHAR(4)') AS [Telefone do Contato],
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/AccessCode/text())[1]', 'CHAR(5)') AS [Ramal do Telefone do Contato], 
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode/text())[1]', 'CHAR(3)') AS [DDD do Fax do Contato],
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix/text())[1]', 'CHAR(4)') + '-' +
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number/text())[1]', 'CHAR(4)') AS [Fax do Contato],
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/AccessCode/text())[1]', 'CHAR(5)') AS [Ramal do Fax do Contato], 
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode/text())[2]', 'CHAR(3)') AS [DDD do Celular do Contato],
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Prefix/text())[2]', 'CHAR(4)') + '-' +
	Bid.ContactPerson.value('(/Person/ContactFone/Fone/Number/text())[2]', 'CHAR(4)') AS [Celular do Contato],
	Bid.ContactPerson.value('(/Person/ContactEmail/Email/Address/text())[1]', 'NVARCHAR(200)') AS [Email], 
	Vendor.Code AS [Código do Representante], --VwLo0CvCod, 
	Vendor.Name AS [Nome do Representante], --VwLo0CvNom, 
	'R' AS [Representante ou Vendedor], 
	'' AS [Código da Condição de Pagamento], 
	'' AS [Descrição da Condição de Pagamento], 
	CAST(Bid.Comments AS VARCHAR(5000)) AS [Observação], 
	'' AS [Referencia], 
	'' AS [Impostos], 
	'MERCANTIL' AS [Tipo de Venda], 
	CAST('1753-01-01' AS datetime) AS [Data da Situação], 
	CAST(' ' AS char(50)) AS [Descrição da Situação], 
	(SELECT TOP (1) 
		LPPED
    FROM          
		dbo.LPV
    WHERE      
		(Bid.Number = LPWBCCADORCNUM)
    ORDER BY 
		LPWBCCADORCNUM DESC) AS [Número do Pedido de Venda],
		
	-- ********************     Dados adicionados pelo Denis    ********************************
	0									As [Probabilidade de Fechamento],
	cast('1753-01-01' AS DATETIME)		As [Data do Próximo Contato],
	''									As [Tipo de Material],
	''									As [Nome dos Concorrentes],
		
	CAST(N'N' AS NVARCHAR(1))			AS [E-mail Enviado],
	cAST('1753-01-01' AS DATETIME)		AS [Data do Envio do E-mail],
	CAST('1753-01-01' AS DATETIME)		AS [Data e Hora do Envio do E-Mail],
	CAST('' AS CHAR(20))				AS [Usuário do Envio do E-Mail],
	CAST(0 AS SMALLINT)					AS [Sequencia do Envio do E-Mail]

	--- ****************************************************************************************		
--INTO LAORVAUX
FROM         
	GESTAOAPP.Sales.Client INNER JOIN
	GESTAOAPP.Sales.Bid ON GESTAOAPP.Sales.Client.Id = GESTAOAPP.Sales.Bid.[Sales.Client.Id] INNER JOIN
	GESTAOAPP.Sales.Vendor ON GESTAOAPP.Sales.Bid.[Sales.Vendor.Id] = GESTAOAPP.Sales.Vendor.Id
WHERE 
	NOT EXISTS (SELECT * 
				FROM GPIMAC_Altamira.dbo.LAORV 
				WHERE laorv.Lo0PED = Bid.Number)















GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LaOrvAgrupadoWBCCAD] TO [interclick]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LaOrvAgrupadoWBCCAD] TO [altanet]
    AS [dbo];

