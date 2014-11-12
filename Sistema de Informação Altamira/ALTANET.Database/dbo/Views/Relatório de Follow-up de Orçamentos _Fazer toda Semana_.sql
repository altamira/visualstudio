





















CREATE VIEW [dbo].[Relatório de Follow-up de Orçamentos (Fazer toda Semana)]
AS
SELECT     
	CONVERT(NVARCHAR(10), Orçamento.[Data do Cadastro], 103) AS [Data do Cadastro],
	ISNULL(CONVERT(NVARCHAR(10), Informações.[Data da Última Atualização], 103), '') AS [Data da Última Atualização],
	ISNULL(Orçamento.Número, '') AS Numero, 
	ISNULL(Orçamento.[Nome Fantasia], '') AS [Nome Fantasia], 
	ISNULL(dbo.Orçamento.Total, '') AS Total, 
	ISNULL(Representante.Nome, '') AS Representante,
	ISNULL((SELECT TOP 1 REPLACE(REPLACE(Observações, CHAR(13), ''), CHAR(10), '') 
	FROM [Histórico da Situação do Orçamento] AS Historico WITH (NOLOCK)
	WHERE HISTORICO.[Número do Orçamento] = Orçamento.Número
	ORDER BY Historico.[Última Atualização] DESC), '') AS [Observações],
	--CASE WHEN Historico.Observações IS NULL THEN '' ELSE Historico.Observações END AS [Observações], 
	CASE 
		WHEN Informações.[Principais Tipos de Materiais] IS NULL OR Informações.[Outros Tipos de Materiais] IS NULL 
		THEN '' ELSE Informações.[Principais Tipos de Materiais] + ' ' + LTRIM(RTRIM(Informações.[Outros Tipos de Materiais])) END AS [Tipo de Material], 
	ISNULL(CAST(Informações.[Probabilidade de Fechamento] / 100 AS FLOAT), '') AS [Probabilidade de Fechamento], 
	CASE 
		WHEN Informações.[Nome dos Principais Concorrentes] IS NULL OR Informações.[Nome de Outros Concorrentes] IS NULL 
		THEN '' ELSE Informações.[Nome dos Principais Concorrentes] + ' ' + Informações.[Nome de Outros Concorrentes] END AS Concorrentes,
	ISNULL(Informações.[Data do Próximo Contato], CAST(' ' AS NVARCHAR(10))) AS [Data do Próximo Contato], 
	ISNULL(Orçamento.[Situação Atual], '') AS [Situação]
FROM        
	dbo.Orçamento WITH (NOLOCK) INNER JOIN 
	Representante.Representante WITH (NOLOCK) ON Orçamento.[Código do Representante] = Representante.[Código] LEFT JOIN 
	dbo.[Informações Adicionais do Orçamento] AS Informações WITH (NOLOCK) ON Orçamento.Número = Informações.[Número do Orçamento]
WHERE     
	--(CAST(Informações.[Data da Última Atualização] AS DATE) >= CAST(DATEADD(WEEK, -1, GETDATE()) AS DATE))
	(CAST(Orçamento.[Data do Cadastro] AS DATE) >= CAST('2012-01-01' AS DATE)) --CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE))
	AND (Orçamento.[Situação Atual] <> 'Fechado' AND Orçamento.[Situação Atual] <> 'Perdido' AND Orçamento.[Situação Atual] <> 'Cancelado' AND Orçamento.[Situação Atual] <> 'Declinado')























