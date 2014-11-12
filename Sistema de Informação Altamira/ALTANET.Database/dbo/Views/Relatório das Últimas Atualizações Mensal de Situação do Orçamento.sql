





















CREATE VIEW [dbo].[Relatório das Últimas Atualizações Mensal de Situação do Orçamento]
AS
SELECT     
	CONVERT(NVARCHAR(10), Informações.[Data da Última Atualização], 103) [Data da Última Atualização],
	Orçamento.Número, 
	Orçamento.[Nome Fantasia], 
	dbo.Orçamento.Total, 
	Representante.Nome AS Representante,
	(SELECT TOP 1 Observações 
	FROM [Histórico da Situação do Orçamento] AS Historico WITH (NOLOCK)
	WHERE HISTORICO.[Número do Orçamento] = Orçamento.Número
	ORDER BY Historico.[Última Atualização] DESC) AS [Observações],
	--CASE WHEN Historico.Observações IS NULL THEN '' ELSE Historico.Observações END AS [Observações], 
	CASE 
		WHEN Informações.[Principais Tipos de Materiais] IS NULL OR Informações.[Outros Tipos de Materiais] IS NULL 
		THEN '' ELSE Informações.[Principais Tipos de Materiais] + ' ' + LTRIM(RTRIM(Informações.[Outros Tipos de Materiais])) END AS [Tipo de Material], 
	CAST(Informações.[Probabilidade de Fechamento] / 100 AS FLOAT) AS [Probabilidade de Fechamento], 
	CASE 
		WHEN Informações.[Nome dos Principais Concorrentes] IS NULL OR Informações.[Nome de Outros Concorrentes] IS NULL 
		THEN '' ELSE Informações.[Nome dos Principais Concorrentes] + ' ' + Informações.[Nome de Outros Concorrentes] END AS Concorrentes,
	Informações.[Data do Próximo Contato], 
	Orçamento.[Situação Atual] AS [Situação]
FROM        
	dbo.Orçamento WITH (NOLOCK) INNER JOIN 
	Representante.Representante WITH (NOLOCK) ON Orçamento.[Código do Representante] = Representante.[Código] INNER JOIN 
	dbo.[Informações Adicionais do Orçamento] AS Informações WITH (NOLOCK) ON Orçamento.Número = Informações.[Número do Orçamento]
WHERE     
	--(CAST(Informações.[Data da Última Atualização] AS DATE) >= CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE))
	(CAST(Informações.[Data da Última Atualização] AS DATE) >= CAST('2012-12-01' AS DATE))






















