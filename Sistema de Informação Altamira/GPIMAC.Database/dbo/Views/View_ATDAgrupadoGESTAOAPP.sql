


CREATE VIEW [dbo].[View_ATDAgrupadoGESTAOAPP]
AS

--DROP TABLE ATDAUX

SELECT
	R.[Id]																		AS [Número]						-- VwAtd0Cod, 
	,CAST('GESTAO' AS NVARCHAR(6))												AS [Origem]						-- VwAtd0Origem, 
	,CAST(R.[DateTime] AS DATE)													AS [Data do Cadastro]						-- VwAtd0Dat, 
	,R.[DateTime]																AS [Data e Hora]				-- VWAtd0DtH, 
	,CAST(U.[FirstName] AS NVARCHAR(20))										AS [Usuário]					-- VwAtd0Aut, 
	,R.[Sales.Client.Id]														AS [Identificador do Cliente]	-- VwAtd0Pc0Cod, 
	,CAST('' AS NVARCHAR(3))													AS [Logradouro]					-- VwAtd0Pc0LogTipCod, 
	,R.LocationAddress.value('(/Address/Street/text())[1]', 'NVARCHAR(50)')		AS [Endereço]					-- VwAtd0Pc0End, 
	,R.LocationAddress.value('(/Address/Number/text())[1]', 'NVARCHAR(10)')		AS [Número do Endereço]						-- VwAtd0Pc0EndNum, 
	,R.LocationAddress.value('(/Address/Complement/text())[1]', 'NVARCHAR(30)') AS [Complemento do Endereço]				-- VwAtd0Pc0EndCpl, 
	,R.LocationAddress.value('(/Address/District/text())[1]', 'NVARCHAR(30)')	AS [Bairro]						-- VwAtd0Pc0Bai, 
	,R.LocationAddress.value('(/Address/PostalCode/text())[1]', 'NVARCHAR(9)')	AS [CEP]						-- VwAtd0Pc0Cep, 
	,R.LocationAddress.value('(/Address/City/text())[1]', 'NVARCHAR(30)')		AS [Cidade]						-- VwAtd0Pc0Cid, 
	,CAST(S.[Acronym] AS NCHAR(2))												AS [Estado]						-- VwAtd0Pc0UfCod, 
	,CAST(C.[CodeName] AS NVARCHAR(20))											AS [Nome Fantasia]				-- VwAtd0Pc0Fan, 
	,CAST(C.[CodeName] AS NVARCHAR(50))											AS [Razão Social]				-- VwAtd0Pc0Nom, 
	,CAST(0 AS SMALLINT)														AS [Código do Contato]			-- VwAtd0Pc1Cod, 
	,R.ContactPerson.value('(/Person/Name)[1]', 'NVARCHAR(40)')					AS [Nome do Contato]			-- VwAtd0Pc1Nom, 
	,R.ContactPerson.value('(/Person/ContactFone/Fone/AreaCode)[1]', 'CHAR(3)') AS [DDD do Telefone do Contato]	-- VwAtd0Pc1TelDdd, 
	,CAST(R.ContactPerson.value('(/Person/ContactFone/Fone/Prefix)[1]', 'NVARCHAR(5)') + 
	'-' + R.ContactPerson.value('(/Person/ContactFone/Fone/Number)[1]', 'NVARCHAR(5)') 
																				AS NVARCHAR(15)) 
																				AS [Telefone do Contato]		-- VwAtd0Pc1TelNum, 
	,R.ContactPerson.value('(/Person/ContactFone/Fone/AccessCode)[1]', 'NVARCHAR(5)') 
																				AS [Ramal do Telefone do Contato]	-- VwAtd0Pc1TelRam, 
	,CAST('' AS NCHAR(3))														AS [DDD do Fax do Contato]		-- VwAtd0Pc1FaxDdd, 
	,CAST('' AS NVARCHAR(15))													AS [Fax do Contato]				-- VwAtd0Pc1FaxNum, 
	,CAST('' AS NCHAR(5))														AS [Ramal do Fax do Contato]	-- VwAtd0Pc1FaxRam, 
	,CAST('' AS NCHAR(3))														AS [DDD do Celular do Contato]	-- VwAtd0Pc1CelDdd, 
	,CAST('' AS NVARCHAR(15))													AS [Celular do Contato]			-- VwAtd0Pc1CelNum, 
	,R.ContactPerson.value('(/Person/Department)[1]', 'NVARCHAR(35)')			AS [Departamento]				-- VwAtd0Pc1Dep, 
	,CAST('' AS NVARCHAR(30))													AS [Cargo]						-- VwAtd0Pc1Cgo, 
	,R.ContactPerson.value('(/Person/ContactEmail/Email/Address/text())[1]', 'NVARCHAR(100)')		AS [Email]						-- VwAtd0Pc1Eml, 
	,CAST(REP.[Code] AS NCHAR(3))												AS [Código do Representante]	-- VwAtd0CvCod, 
	,CAST(REP.[Name] AS NVARCHAR(30))											AS [Nome do Representante]		-- VwAtd0CvNom, 
	,CAST(0 AS INT)																AS [Código do Tipo de Atendimento]		-- VwAtd0TpA0Cod, 
	,CAST('SOLICITAÇÃO DE VISITA' AS NVARCHAR(100))								AS [Descrição do Tipo de Atendimento]	-- VwAtd0TpA0Nom, 
	,CAST(0	AS INT)																AS [Código da Situação]			-- VwAtd0StA0Cod, 
	,CAST('AGUARDANDO VISITA DO REPRESENTANTE' AS NVARCHAR(100))				AS [Descrição da Situação]		-- VwAtd0StA0Nom, 
	,CAST(CASE	WHEN M.Id IN (0, 1, 2) THEN 4 
				WHEN M.Id = 4 THEN 8
				WHEN M.Id = 5 THEN 1 
				WHEN M.Id IN (6, 7) THEN 9
				WHEN M.Id = 8 THEN 7
				WHEN M.Id IN (9, 10, 11) THEN 5
				WHEN M.Id = 12 THEN 2 
				ELSE M.Id END AS INT)											AS [Código da Mídia]			-- VwAtd0MdA0Cod, 
	,CAST(CASE	WHEN M.Id IN (0, 1, 2) THEN 'JÁ É CLIENTE' 
				WHEN M.Id = 4 THEN 'INTERNET'
				WHEN M.Id = 5 THEN 'GOOGLE' 
				WHEN M.Id IN (6, 7) THEN 'LISTA OESP, PAG. AMARELAS'
				WHEN M.Id = 8 THEN 'FEIRA'
				WHEN M.Id IN (9, 10, 11) THEN 'REVISTA'
				WHEN M.Id = 12 THEN 'SITE DA ALTAMIRA'
				WHEN M.Id = 3 THEN 'INDICAÇÃO' 
				ELSE 'JÁ É CLIENTE' END AS NVARCHAR(100))						AS [Descrição da Mídia]			-- VwAtd0MdA0Nom, 
	,CAST(R.[Comments] AS NVARCHAR(2000))										AS [Observações]				-- VwAtd0Obs, 
	,CAST('' AS NVARCHAR(1000))													AS [Mensagem SMS]				-- VwAtd0SmsTxt, 
	,CAST('S' AS NCHAR(1))														AS [SMS Enviado]				-- VwAtd0SmsEnv, 
	,CAST(U.[FirstName]	AS NVARCHAR(20))										AS [Usuário que Envio SMS]		-- VwAtd0SmsOkUsu, 
	,cAST(R.[DateTime] AS DateTime)												AS [Data e Hora do Envio]		-- VwAtd0SmsOkDtH, 
	,CAST('S' AS NCHAR(1))														AS [SMS Ok]						-- VwAtd0SmsOk	
--INTO ATDAUX
FROM 
	GESTAOAPP.Attendance.Register AS R INNER JOIN 
	GESTAOAPP.Sales.Client AS C ON R.[Sales.Client.Id] = C.[Id] INNER JOIN 
	GESTAOAPP.Contact.Media AS M ON C.[Contact.Media.Id] = M.Id INNER JOIN
	GESTAOAPP.Sales.Vendor AS REP ON R.[Sales.Vendor.Id] = REP.[Id] INNER JOIN
	GESTAOAPP.[Security].[User] U ON R.[CreateBy.Security.User.Id] = U.[Id] INNER JOIN
	GESTAOAPP.[Location].[City] CTY ON R.LocationAddress.value('(/Address/City/@Id)[1]', 'INT') = CTY.[Id] INNER JOIN
	GESTAOAPP.[Location].[State] S ON CTY.[Location.State.Id] = S.[Id]

--GRANT SELECT ON ATDAUX TO altanet



GO
GRANT SELECT
    ON OBJECT::[dbo].[View_ATDAgrupadoGESTAOAPP] TO [interclick]
    AS [dbo];

