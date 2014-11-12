CREATE VIEW View_GESTAO_CondicaoPagto AS

	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias1] AS INT) AS Prazo, CAST([vepe_Porcentagem1] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha1] AS SMALLINT) AS Escolha, CAST([vepe_Tipo1] AS CHAR(1)) AS Tipo, CAST([vepe_Valor1] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem1] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias2] AS INT) AS Prazo, CAST([vepe_Porcentagem2] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha2] AS SMALLINT) AS Escolha, CAST([vepe_Tipo2] AS CHAR(1)) AS Tipo, CAST([vepe_Valor2] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem2] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias3] AS INT) AS Prazo, CAST([vepe_Porcentagem3] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha3] AS SMALLINT) AS Escolha, CAST([vepe_Tipo3] AS CHAR(1)) AS Tipo, CAST([vepe_Valor3] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem3] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias4] AS INT) AS Prazo, CAST([vepe_Porcentagem4] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha4] AS SMALLINT) AS Escolha, CAST([vepe_Tipo4] AS CHAR(1)) AS Tipo, CAST([vepe_Valor4] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem4] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias5] AS INT) AS Prazo, CAST([vepe_Porcentagem5] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha5] AS SMALLINT) AS Escolha, CAST([vepe_Tipo5] AS CHAR(1)) AS Tipo, CAST([vepe_Valor5] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem5] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias6] AS INT) AS Prazo, CAST([vepe_Porcentagem6] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha6] AS SMALLINT) AS Escolha, CAST([vepe_Tipo6] AS CHAR(1)) AS Tipo, CAST([vepe_Valor6] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem6] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias7] AS INT) AS Prazo, CAST([vepe_Porcentagem7] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha7] AS SMALLINT) AS Escolha, CAST([vepe_Tipo7] AS CHAR(1)) AS Tipo, CAST([vepe_Valor7] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem7] > 0
	UNION
	SELECT CAST([vepe_Pedido] AS INT) AS Pedido, CAST([vepe_Dias8] AS INT) AS Prazo, CAST([vepe_Porcentagem8] AS FLOAT) AS Porcentagem, CAST([vepe_Escolha8] AS SMALLINT) AS Escolha, CAST([vepe_Tipo8] AS CHAR(1)) AS Tipo, CAST([vepe_Valor8] AS MONEY) AS Valor FROM [DBALTAMIRA].[dbo].[VE_Pedidos] WHERE [vepe_Porcentagem8] > 0

