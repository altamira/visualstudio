
CREATE PROCEDURE [Preenche o Plano de Contas no Cadastro de Clientes]
AS

UPDATE 
	GPIMAC_Altamira.dbo.CACLI 
SET 
	CCCaPlC0Cod = '1.01.03'
WHERE
	LTRIM(RTRIM(CCCLA)) <> 'FO' 
	AND (LTRIM(RTRIM(CCCaPlC0Cod)) = '' OR LTRIM(RTRIM(CCCaPlC0Cod)) IS NULL)

