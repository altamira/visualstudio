﻿/****** Script do comando SelectTopNRows de SSMS  ******/

CREATE VIEW CONTMATIC_EMPRESA 
AS

SELECT 
	UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
	CASE WHEN LEN(LTRIM(RTRIM(ISNULL(CCFAN, '')))) > 0 THEN LEFT(LTRIM(RTRIM(CCFAN)) + SPACE(8), 8)
		 ELSE LEFT(LTRIM(RTRIM(ISNULL(CCNOM, ''))) + SPACE(8), 8) END --AS APELIDO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCNOM, ''))) + SPACE(38), 38) --AS RAZAO_SOCIAL
	+ LEFT(LTRIM(RTRIM(CAST(ISNULL(CALOGTIP.[LogTip0Num], '') AS CHAR(2)))) + SPACE(2), 2) --AS TIPO_LOGRADOURO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCEND, ''))) + SPACE(41), 41) --AS LOGRADOURO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCENDNUM, ''))) + SPACE(10), 10) --AS NUMERO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCENDCPL, ''))) + SPACE(15), 15) --AS COMPLEMENTO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCBAI, ''))) + SPACE(18), 18) --AS BAIRRO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCCEP, ''))) + SPACE(9), 9) --AS CEP
	+ LEFT(LTRIM(RTRIM(ISNULL(CCCID, ''))) + SPACE(31), 31) --AS CIDADE
	+ LEFT(LTRIM(RTRIM(ISNULL(CECOD, ''))) + SPACE(2), 2) --AS ESTADO
	+ LEFT(LTRIM(RTRIM(ISNULL(CCCGC, ''))) + SPACE(18), 18) --AS CNPJ
	+ LEFT(LTRIM(RTRIM(ISNULL(CCINS, ''))) + SPACE(21), 21) --AS INSCRICAO_ESTADUAL
	+ '000000' --AS CODIGO_ATIVIDADE
	+ '01/01/1900' --AS INICIO_ATIVIDADE
	+ SPACE(38) --AS NOME_RESPONSAVEL
	+ SPACE(20) --AS QUALIFICACAO_RESPONSAVEL
	+ SPACE(14) --AS CPF_RESPONSAVEL
	+ SPACE(20) --AS FONE_RESPONSAVEL 
	, 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O'), 'É', 'E'), 'Í', 'I'), 'Ú', 'U'), '&', 'E'), '–', ' '))
	AS REGISTRO
FROM [GPIMAC_Altamira].[dbo].[CACLI] INNER JOIN 
	(SELECT LEFT([CCCGC], 10) + RIGHT(MIN([CCCGC]), 8) AS [CLICCCGC]
	FROM [GPIMAC_Altamira].[dbo].[CACLI]
	WHERE LEN([CCCGC]) = 18
		AND ISNUMERIC(REPLACE(REPLACE(REPLACE(ISNULL([CCCGC], ''), '.', ''), '/', ''), '-', '')) > 0
		AND CAST(LEFT(REPLACE(REPLACE(REPLACE(ISNULL([CCCGC], ''), '.', ''), '/', ''), '-', ''), 10) AS NUMERIC(10,0)) > 0
		 /*AND CCNOM LIKE 'POLIMPORT%'*/
	GROUP BY LEFT([CCCGC], 10)) AS CLICGC ON CACLI.CCCGC = CLICGC.[CLICCCGC] INNER JOIN
	CALOGTIP ON CALOGTIP.LogTip0Cod = [CACLI].[CCLogTip0CodP]
WHERE LEN([CCCGC]) = 18 
	AND LTRIM(RTRIM([CCFAN])) <> 'ALTAMIRA' AND LTRIM(RTRIM([CCNOM])) <> 'ALTAMIRA'
	AND NOT [CCFAN] IS NULL AND NOT [CCNOM] IS NULL
	AND LEN(LTRIM(RTRIM(CCNOM))) > 5
	AND (SELECT COUNT(*) FROM CACLI N WHERE 
		CASE WHEN LEN(LTRIM(RTRIM(ISNULL(N.CCFAN, '')))) > 0 THEN LEFT(LTRIM(RTRIM(N.CCFAN)) + SPACE(8), 8)
		ELSE LEFT(LTRIM(RTRIM(ISNULL(N.CCNOM, ''))) + SPACE(8), 8) END = 
		CASE WHEN LEN(LTRIM(RTRIM(ISNULL(CACLI.CCFAN, '')))) > 0 THEN LEFT(LTRIM(RTRIM(CACLI.CCFAN)) + SPACE(8), 8)
		ELSE LEFT(LTRIM(RTRIM(ISNULL(CACLI.CCNOM, ''))) + SPACE(8), 8) END) = 1
--AND CCNOM LIKE 'POLIMPORT%'
--GROUP BY LEFT([CCCGC], 10)
--ORDER BY [CCDTA] DESC


--SELECT [CCCGC], [CCNOM]
--FROM CACLI
--WHERE CCNOM LIKE 'POLIMPORT%'