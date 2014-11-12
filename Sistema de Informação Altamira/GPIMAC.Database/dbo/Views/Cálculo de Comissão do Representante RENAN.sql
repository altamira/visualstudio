
/****** Script do comando SelectTopNRows de SSMS  ******/
CREATE VIEW [dbo].[Cálculo de Comissão do Representante RENAN]
AS
SELECT --[Empresa]
      [Número]
      ,CONVERT(NVARCHAR(10), [Data da Emissao], 103) AS [Data da Emissao]
      --,[CNPJ do Cliente]
      ,[Razao Social]
      --,[Código da Condição de Pagamento]
      --,[Código do Representante]
      ,CAST([Percentual de Comissão] AS FLOAT) AS [Percentual de Comissão]
      ,CAST([Valor dos Produtos] AS MONEY) AS [Valor dos Produtos]
      ,CAST([Valor do IPI] AS MONEY) AS [Valor do IPI]
      ,CAST([Valor Total] AS MONEY) AS [Valor Total]
      ,CAST([Valor da Comissão] AS MONEY) AS [Valor da Comissão]
  FROM [OLAP].[dbo].[Pedidos de Venda para Cálculo de Comissão de Vendedor]
  WHERE [Código do Representante] = '121' AND [Número] > 69260
  --ORDER BY [Número]
