


















CREATE VIEW [Representante].[Acompanhamento do Orçamento]
AS

SELECT  
	Informações.[Número do Orçamento],
	Informações.[Principais Tipos de Materiais],
	Informações.[Outros Tipos de Materiais],
	Informações.[Probabilidade de Fechamento],
	Informações.[Probabilidade de Fechamento] / 100 AS [Probabilidade de Fechamento em Percentual],
	Informações.[Nome dos Principais Concorrentes],
	Informações.[Nome de Outros Concorrentes],
	Informações.[Data do Próximo Contato],
	--Historico.[Última Atualização],
	--(SELECT TOP 1 [Última Atualização]	FROM [Histórico da Situação do Orçamento] AS Historico WHERE Historico.[Número do Orçamento] = Informações.[Número do Orçamento] ORDER BY [Última Atualização] DESC) AS [Última Atualização],
	Informações.[Data da Última Atualização] AS [Última Atualização],
	--CASE WHEN Historico.[Situação] IS NULL THEN 'Pendente' ELSE Historico.[Situação] END [Situação],
	Informações.[Última Situação Informada],
	CASE 
		WHEN WBCCAD.Orçamento.Total IS NULL THEN 'Aguardando Orçamento' ELSE 
			CASE 
				WHEN [Pedido de Venda].[Número do Orçamento] IS NULL THEN 
					CASE WHEN Informações.[Última Situação Informada] IS NULL 
						THEN 'Pendente' 
						ELSE Informações.[Última Situação Informada] 
					END
				ELSE 'Fechado' 
			END 
	END AS [Situação Atual],
	--Historico.[Observações]
	(SELECT TOP 1 Historico.[Observações] 
	FROM dbo.[Histórico da Situação do Orçamento] Historico 
	WHERE Historico.[Número do Orçamento] = Informações.[Número do Orçamento] 
	ORDER BY [Última Atualização] DESC) AS [Observações]
FROM 
	[Informações Adicionais do Orçamento] AS Informações WITH (NOLOCK) INNER JOIN
	WBCCAD.Orçamento ON WBCCAD.Orçamento.Número = Informações.[Número do Orçamento] LEFT JOIN
	(SELECT DISTINCT [Número do Orçamento] FROM [Pedido de Venda]) AS [Pedido de Venda] ON [Pedido de Venda].[Número do Orçamento] = Informações.[Número do Orçamento]
WHERE ISNUMERIC(WBCCAD.Orçamento.Número) = 1


















