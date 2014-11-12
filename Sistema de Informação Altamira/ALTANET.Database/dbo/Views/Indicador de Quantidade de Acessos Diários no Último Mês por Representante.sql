

/****** Script do comando SelectTopNRows de SSMS  ******/
CREATE VIEW [dbo].[Indicador de Quantidade de Acessos Diários no Último Mês por Representante]
AS
SELECT CAST([Sessão de Representante].[Data de Criação] AS DATE) AS [Data do Acesso],
		MIN(Representante.Nome) as Representante,
		COUNT(*) AS [Número de Acessos]
  FROM 
	[ALTANET].[dbo].[Sessão de Representante] INNER JOIN
	[ALTANET].[dbo].[Representante] ON [Sessão de Representante].[Identificador do Representante] = Representante.Identificador
  WHERE 
	--[Identificador do Representante] <> 1
	--AND [Identificador do Representante] <> 2
	CAST([Sessão de Representante].[Data de Criação] AS DATE) >= CAST(DATEADD(MONTH,-1,GETDATE()) AS DATE)
  GROUP BY CAST([Sessão de Representante].[Data de Criação] AS DATE), Representante.Nome
  --ORDER BY CAST([Sessão de Representante].[Data de Criação] AS DATE) DESC, Representante.Nome
  

