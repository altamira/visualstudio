CREATE PROCEDURE [dbo].[_GPIMAC_INSERT_CLIENTESNOVO]

AS

--BEGIN TRANSACTION
UPDATE [DBALTAMIRA].[dbo].[VE_ClientesNovo] SET
			--VE.vecl_Codigo = CAST(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(CACLI.CCCGC, '.', ''), '/', ''), '-', ''), ' ', ''))) AS CHAR(14)), 
			vecl_Abreviado = CAST(LEFT(LTRIM(RTRIM(CACLI.CCFAN)), 14) AS CHAR(14)), 
			vecl_Nome = CAST(LEFT(LTRIM(RTRIM(CACLI.CCNOM)), 50) AS VARCHAR(50)), 
			vecl_Endereco = CAST(LEFT((CASE WHEN LOGENTREGA.LogTip0Nom IS NULL THEN '' ELSE LTRIM(RTRIM(LOGENTREGA.LogTip0Nom)) + ' ' END) + 
							LTRIM(RTRIM(CACLI.CCEND)) + ' ' + 
							LTRIM(RTRIM(CACLI.CCENDNUM)) + ' ' + 
							LTRIM(RTRIM(CACLI.CCENDCPL)), 50) AS VARCHAR(50)), 
			vecl_Bairro = CAST(LEFT(CACLI.CCBAI, 25) AS CHAR(25)), 
			vecl_Cidade = CAST(LEFT(CACLI.CCCID, 25) AS CHAR(25)), 
			vecl_Estado = CAST(LEFT(CACLI.CECOD, 2) AS CHAR(2)), 
			--vecl_Municipio = '', 
			vecl_Cep = CAST(LEFT(CACLI.CCCEP, 9) AS CHAR(9)), 
			vecl_Inscricao = CAST(LEFT(CACLI.CCINS, 14) AS CHAR(14)), 
			vecl_Contato = CAST(LEFT(CACLI.CCOBS, 20) AS VARCHAR(20)), 
			--'' AS vecl_Departamento, 
			vecl_Telefone = CAST(LEFT(CACLI.CCFON, 10) AS CHAR(10)), 
			vecl_Fax = CAST(LEFT(CACLI.CCFAX, 10) AS CHAR(10)), 
			vecl_DDD = CAST(LEFT(CACLI.CCFDD, 4) AS CHAR(4)), 
			vecl_Representante = LEFT(CASE WHEN CAST(CACLI.CVCOD AS CHAR(3)) IS NULL THEN '001' ELSE CAST(CACLI.CVCOD AS CHAR(3)) END, 3), 
			vecl_Observacao = CAST(LEFT(CACLI.CCOBS, 55) AS VARCHAR(55)), 
			--'' AS vecl_Credito, 
			vecl_Email = CAST(LEFT(CACLI.CCMAIL, 40) AS VARCHAR(40)), 
			vecl_TipoPessoa = CAST('J' AS CHAR(1)), 
			vecl_Transportadora = CAST(1 AS INT), 
			--CAST('' AS VARCHAR(12)) AS vecl_NumeroRG, NULL AS vecl_DataNascimento, 
			vecl_CobEndereco =	CAST(LEFT((CASE WHEN LOGCOBRANCA.LogTip0Nom IS NULL THEN '' ELSE LTRIM(RTRIM(LOGCOBRANCA.LogTip0Nom)) + ' ' END) + 
								LTRIM(RTRIM(CACLI.CCCEN)) + ' ' + 
								LTRIM(RTRIM(CACLI.CCCENNUM)) + ' ' + 
								LTRIM(RTRIM(CACLI.CCCENCPL)), 40) AS VARCHAR(40)), 
			vecl_CobBairro = CAST(LEFT(CACLI.CCCBA, 25) AS VARCHAR(25)), 
			vecl_CobCidade = CAST(LEFT(CACLI.CCCCI, 25) AS VARCHAR(25)), 
			vecl_CobEstado = CAST(LEFT(CACLI.CCCES, 2) AS VARCHAR(2)), 
			vecl_CobCep = CAST(LEFT(CACLI.CCCcEP, 9) AS VARCHAR(9)), 
			vecl_CobDDD = CAST(LEFT(CACLI.CCDD5,4) AS VARCHAR(4)), 
			vecl_CobTelefone = CAST(LEFT(CACLI.CCtFO3, 10) AS VARCHAR(10)), 
			vecl_CobFax = CAST(LEFT(CACLI.CCFA2, 10) AS VARCHAR(10)), 
			vecl_CobEmail = CAST(LEFT(CACLI.CCMAIL, 40) AS VARCHAR(40))
--SELECT * 
FROM [DBALTAMIRA].[dbo].[VE_ClientesNovo], GPIMAC_Altamira.dbo.CACLI AS CACLI 
LEFT JOIN GPIMAC_Altamira.dbo.CALOGTIP AS LOGENTREGA ON CACLI.CCLogTip0CodP = LOGENTREGA.LogTip0Cod
LEFT JOIN GPIMAC_Altamira.dbo.CALOGTIP AS LOGCOBRANCA ON CACLI.CCLogTip0CodP = LOGCOBRANCA.LogTip0Cod
WHERE LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(CACLI.CCCGC, '.', ''), '/', ''), '-', ''), ' ', ''))) = vecl_Codigo AND
(LTRIM(RTRIM(CACLI.CCCLA)) = 'CL' OR LTRIM(RTRIM(CACLI.CCCLA)) = 'CF') AND LEN(LTRIM(RTRIM(CACLI.CCCGC))) > 16 
--COMMIT TRANSACTION

/*
INSERT INTO [DBALTAMIRA].[dbo].[VE_ClientesNovo]
SELECT     CAST(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(CCCGC, '.', ''), '/', ''), '-', ''), ' ', ''))) AS CHAR(14)) AS vecl_Codigo, CAST(LTRIM(RTRIM(CCFAN)) AS CHAR(14)) AS vecl_Abreviado, 
                      CAST(LTRIM(RTRIM(CCNOM)) AS VARCHAR(50)) AS vecl_Nome, CAST(LTRIM(RTRIM(CCEND)) + ' ' + LTRIM(RTRIM(CCENDNUM)) + ' ' + LTRIM(RTRIM(CCENDCPL)) AS VARCHAR(50)) AS vecl_Endereco, CAST(CCBAI AS CHAR(25)) AS vecl_Bairro, 
                      CAST(CCCID AS CHAR(25)) AS vecl_Cidade, CAST(CECOD AS CHAR(2)) AS vecl_Estado, '' AS vecl_Municipio, CAST(CCCEP AS CHAR(9)) AS vecl_Cep, CAST(CCINS AS CHAR(14)) AS vecl_Inscricao, CAST(CCCON AS VARCHAR(25)) AS vecl_Contato, 
                      '' AS vecl_Departamento, CAST(CCFON AS CHAR(10)) AS vecl_Telefone, CAST(CCFAX AS CHAR(10)) AS vecl_Fax, CAST(CCFDD AS CHAR(4)) AS vecl_DDD, CASE WHEN CAST(CVCOD AS CHAR(3)) IS NULL THEN '001' ELSE CAST(CVCOD AS CHAR(3)) END AS vecl_Representante, CAST(CCOBS AS VARCHAR(55)) AS vecl_Observacao, 
                      '' AS vecl_Credito, CAST(CCMAIL AS VARCHAR(40)) AS vecl_Email, CAST('J' AS CHAR(1)) AS vecl_TipoPessoa, CAST(1 AS INT) AS vecl_Transportadora, CAST('' AS VARCHAR(12)) AS vecl_NumeroRG, NULL AS vecl_DataNascimento, 
                      CAST(LTRIM(RTRIM(CCCEN)) + ' ' + LTRIM(RTRIM(CCCENNUM)) + ' ' + LTRIM(RTRIM(CCCENCPL)) AS VARCHAR(40)) AS vecl_CobEndereco, CAST(CCCBA AS VARCHAR(25)) AS vecl_CobBairro, 
                      CAST(CCCCI AS VARCHAR(25)) AS vecl_CobCidade, CAST(CCCES AS VARCHAR(2)) AS vecl_CobEstado, CAST(CCCcEP AS VARCHAR(9)) AS vecl_CobCep, CAST(CCDD5 AS VARCHAR(4)) AS vecl_CobDDD, CAST(CCtFO3 AS VARCHAR(10)) AS vecl_CobTelefone, CAST(CCFA2 AS VARCHAR(10)) AS vecl_CobFax, 
                      CAST(CCMAIL AS VARCHAR(40)) AS vecl_CobEmail, GETDATE() AS vecl_UltimaCompra, NULL AS vecl_VlUltimaCompra, NULL AS vecl_StatusUltimaCompra, NULL AS vecl_Acumulado, NULL 
                      AS vecl_QtdeCompras, NULL AS vecl_MaiorCompra, NULL AS vecl_vlMaiorCompra, NULL AS vecl_StatusMaiorCompra, NULL AS vecl_PrimeiraCompra, NULL 
                      AS vecl_VlPrimeiraCompra, NULL AS vecl_StatusPrimeiraCompra, NULL AS vecl_SUFRAMA, NULL AS vecl_Lock
FROM         GPIMAC_Altamira.dbo.CACLI
WHERE (LTRIM(RTRIM(CCCLA)) = 'CL' OR LTRIM(RTRIM(CCCLA)) = 'CF') AND LEN(LTRIM(RTRIM(CCCGC))) > 16 AND 
--LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(CCCGC, '.', ''), '/', ''), '-', ''), ' ', ''))) = '00069851662887' AND
NOT EXISTS
          (SELECT     *
            FROM         [DBALTAMIRA].[dbo].[VE_ClientesNovo]
            WHERE      LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(CCCGC, '.', ''), '/', ''), '-', ''), ' ', ''))) = vecl_Codigo)
         
*/
         