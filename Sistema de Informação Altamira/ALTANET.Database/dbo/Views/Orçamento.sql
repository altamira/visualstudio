
























CREATE VIEW [dbo].[Orçamento]
AS

SELECT 
	GPIMAC_Altamira.dbo.LAORVAUX.[Empresa]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Número]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Revisão]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Codigo da Situação]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Origem]
	,CAST(GPIMAC_Altamira.dbo.LAORVAUX.[Data do Cadastro] AS DATE) AS [Data do Cadastro]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Data de Validade]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Nome do Usuário]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Cliente]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Nome Fantasia]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Razão Social]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Logradouro]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Endereço]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Número do Endereço]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Complemento do Endereço]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Bairro]
	,GPIMAC_Altamira.dbo.LAORVAUX.[CEP]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Cidade]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Estado]
	,GPIMAC_Altamira.dbo.LAORVAUX.[DDD do Telefone]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Telefone]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Ramal do Telefone]
	,GPIMAC_Altamira.dbo.LAORVAUX.[DDD do Fax]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Fax]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Ramal do Fax]
	,GPIMAC_Altamira.dbo.LAORVAUX.[ID do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Nome do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Departamento do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Cargo do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[DDD do Telefone do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Telefone do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Ramal do Telefone do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[DDD do Fax do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Fax do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Ramal do Fax do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[DDD do Celular do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Celular do Contato]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Email]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Código do Representante]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Nome do Representante]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Representante ou Vendedor]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Código da Condição de Pagamento]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Descrição da Condição de Pagamento]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Observação]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Referencia]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Impostos]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Tipo de Venda]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Data da Situação]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Descrição da Situação]
	,GPIMAC_Altamira.dbo.LAORVAUX.[Número do Pedido de Venda]
	--,GPIMAC_Altamira.dbo.LAORVAUX.[Probabilidade de Fechamento]
	--,GPIMAC_Altamira.dbo.LAORVAUX.[Data do Próximo Contato]
	--,GPIMAC_Altamira.dbo.LAORVAUX.[Tipo de Material]
	--,GPIMAC_Altamira.dbo.LAORVAUX.[Nome dos Concorrentes]
	,CASE WHEN ISNULL(WBCCAD.Orçamento.Situação, 0) > 30 THEN ISNULL(WBCCAD.Orçamento.Total, 0) ELSE 0 END AS [Total]
	,ISNULL(Acompanhamento.[Principais Tipos de Materiais], '') AS [Principais Tipos de Materiais]
	,ISNULL(Acompanhamento.[Outros Tipos de Materiais], '') AS [Outros Tipos de Materiais]
	,ISNULL(Acompanhamento.[Probabilidade de Fechamento], 0) AS [Probabilidade de Fechamento]
	,ISNULL(Acompanhamento.[Probabilidade de Fechamento em Percentual], 0) AS [Probabilidade de Fechamento em Percentual]
	,ISNULL(Acompanhamento.[Nome dos Principais Concorrentes], '') AS [Nome dos Principais Concorrentes]
	,ISNULL(Acompanhamento.[Nome de Outros Concorrentes], '') AS [Nome de Outros Concorrentes]
	--,Acompanhamento.[Data do Próximo Contato]
	,ISNULL(Acompanhamento.[Data do Próximo Contato], GETDATE()) AS [Data do Próximo Contato]
	,Acompanhamento.[Última Atualização]
	--,CASE WHEN Acompanhamento.[Situação] IS NULL THEN 'Pendente' ELSE Acompanhamento.[Situação] END AS [Situação]
	,ISNULL(Acompanhamento.[Situação Atual], 'Pendente') AS Situação
	,CASE 
		WHEN [Pedido de Venda].[Número] IS NULL THEN 
			CASE WHEN WBCCAD.Orçamento.Situação < 30 THEN 'Em Projeto'
					WHEN WBCCAD.Orçamento.Situação = 30 THEN 'Ficha Financeira'
					WHEN WBCCAD.Orçamento.Situação > 30 AND WBCCAD.Orçamento.Situação < 70 THEN ISNULL(Acompanhamento.[Situação Atual], 'Pendente') 
					WHEN WBCCAD.Orçamento.Situação = 70 OR Acompanhamento.[Situação Atual] = 'Suspenso' THEN 'Suspenso'
					WHEN WBCCAD.Orçamento.Situação = 90 OR Acompanhamento.[Situação Atual] = 'Perdido' THEN 'Perdido'
					WHEN WBCCAD.Orçamento.Situação = 99 OR Acompanhamento.[Situação Atual] = 'Cancelado' THEN 'Cancelado'
					ELSE 'Em Projeto' END
		ELSE 'Fechado' END 
	AS [Situação Atual]
	,ISNULL(Acompanhamento.[Observações], '') AS [Observações]
FROM 
	GPIMAC_Altamira.dbo.LAORVAUX WITH (NOLOCK) LEFT JOIN 
	WBCCAD.Orçamento WITH (NOLOCK) ON GPIMAC_Altamira.dbo.LAORVAUX.Número = REPLACE(STR(WBCCAD.Orçamento.Número, 8, 0), ' ', '0') LEFT JOIN 
	[Acompanhamento do Orçamento] AS Acompanhamento WITH (NOLOCK) ON LAORVAUX.Número = REPLACE(STR(Acompanhamento.[Número do Orçamento], 8, 0), ' ', '0') LEFT JOIN
	(SELECT DISTINCT [Pedido de Venda].Número, REPLACE(STR([Pedido de Venda].[Número do Orçamento], 8, 0), ' ', '0') AS [Número do Orçamento] FROM [Pedido de Venda] WITH (NOLOCK)) AS [Pedido de Venda] ON [Pedido de Venda].[Número do Orçamento] = GPIMAC_Altamira.dbo.LAORVAUX.Número
UNION
SELECT 
	GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Emp]			--Empresa
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Ped]			--Número
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Rev]			--Revisão
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Sit]			--Codigo da Situação
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Origem]		--Origem
	,CAST(GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Dat] AS DATE) AS 	[VwLo0Dat]		--Data do Cadastro
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0DatVal]		--Data de Validade
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Fei]			--Nome do Usuário
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0Cod]			--Cliente
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0Fan]			--Nome Fantasia
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0Nom]			--Razão Social
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0LogTipCod]		--Logradouro
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0End]			--Endereço
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0EndNum]		--Número do Endereço
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0EndCpl]		--Complemento do Endereço
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0Bai]			--Bairro
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0Cep]			--CEP
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0Cid]			--Cidade
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0UfCod]			--Estado
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0TelDdd]		--DDD do Telefone
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0TelNum]		--Telefone
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0TelRam]		--Ramal do Telefone
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0FaxDdd]		--DDD do Fax
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0FaxNum]		--Fax
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc0FaxRam]		--Ramal do Fax
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Pc1Cod]		--ID do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1Nom]			--Nome do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1Dep]			--Departamento do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1Cgo]			--Cargo do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1TelDdd]		--DDD do Telefone do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1TelNum]		--Telefone do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1TelRam]		--Ramal do Telefone do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1FaxDdd]		--DDD do Fax do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1FaxNum]		--Fax do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1FaxRam]		--Ramal do Fax do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1CelDdd]		--DDD do Celular do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1CelNum]		--Celular do Contato
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwPc1Eml]			--Email
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0CvCod]			--Código do Representante
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0CvNom]			--Nome do Representante
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0CvTip]			--Representante ou Vendedor
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0CpCod]			--Código da Condição de Pagamento
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0CpNom]			--Descrição da Condição de Pagamento
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Obs]			--Observação
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0Ref]			--Referencia
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0ImpDsc]		--Impostos
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0TipVend]		--Tipo de Venda
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0SitDat]		--Data da Situação
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0SitDes]		--Descrição da Situação
	,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0LpPPed]		--Número do Pedido de Venda
	--,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0ProbFec]		--Probabilidade de Fechamento
	--,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0DatProxCont]	--Data do Próximo Contato
	--,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0TipMaterial]	--Tipo de Material
	--,GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].[VwLo0NomConcorr]	--Nome dos Concorrentes
	--,ISNULL(WBCCAD.Orçamento.Total, 0) AS Total
	,CASE WHEN ISNULL(WBCCAD.Orçamento.Situação, 0) > 30 THEN ISNULL(WBCCAD.Orçamento.Total, 0) ELSE 0 END AS [Total]
	,ISNULL(Acompanhamento.[Principais Tipos de Materiais], '') AS [Principais Tipos de Materiais]
	,ISNULL(Acompanhamento.[Outros Tipos de Materiais], '') AS [Outros Tipos de Materiais]
	,ISNULL(Acompanhamento.[Probabilidade de Fechamento], 0) AS [Probabilidade de Fechamento]
	,ISNULL(Acompanhamento.[Probabilidade de Fechamento em Percentual], 0) AS [Probabilidade de Fechamento em Percentual]
	,ISNULL(Acompanhamento.[Nome dos Principais Concorrentes], '') AS [Nome dos Principais Concorrentes]
	,ISNULL(Acompanhamento.[Nome de Outros Concorrentes], '') AS [Nome de Outros Concorrentes]
	--,Acompanhamento.[Data do Próximo Contato]
	,ISNULL(Acompanhamento.[Data do Próximo Contato], GETDATE()) AS [Data do Próximo Contato]
	,Acompanhamento.[Última Atualização]
	--,CASE WHEN Acompanhamento.[Situação] IS NULL THEN 'Pendente' ELSE Acompanhamento.[Situação] END AS [Situação]
	,ISNULL(Acompanhamento.[Situação Atual], 'Pendente') AS  Situação
	--,CASE WHEN WBCCAD.Orçamento.Total IS NULL THEN 'Aguardando Orçamento' ELSE dbo.[Situação Atual do Orçamento](WBCCAD.Orçamento.Número, Acompanhamento.[Última Situação Informada]) END AS [Situação Atual]
	,CASE 
		WHEN [Pedido de Venda].[Número] IS NULL THEN 
			CASE	WHEN WBCCAD.Orçamento.Situação < 30 THEN 'Em Projeto'
					WHEN WBCCAD.Orçamento.Situação = 30 THEN 'Ficha Financeira'
					WHEN WBCCAD.Orçamento.Situação > 30 AND WBCCAD.Orçamento.Situação < 70 THEN ISNULL(Acompanhamento.[Situação Atual], 'Pendente') 
					WHEN WBCCAD.Orçamento.Situação = 70 OR Acompanhamento.[Situação Atual] = 'Suspenso' THEN 'Suspenso'
					WHEN WBCCAD.Orçamento.Situação = 90 OR Acompanhamento.[Situação Atual] = 'Perdido' THEN 'Perdido'
					WHEN WBCCAD.Orçamento.Situação = 99 OR Acompanhamento.[Situação Atual] = 'Cancelado' THEN 'Cancelado'
					ELSE 'Em Projeto' END
		ELSE 'Fechado' END 
	AS [Situação Atual]
	,ISNULL(Acompanhamento.[Observações], '') AS [Observações]
FROM 
	GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01] WITH (NOLOCK) 
	LEFT JOIN WBCCAD.Orçamento WITH (NOLOCK) ON REPLACE(STR(GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].VwLo0Ped, 8, 0), ' ', '0') = REPLACE(STR(WBCCAD.Orçamento.Número, 8, 0), ' ', '0') 
	LEFT JOIN [Acompanhamento do Orçamento] AS Acompanhamento WITH (NOLOCK) ON [View_LaOrVAgrupadoAux01].VwLo0Ped = Acompanhamento.[Número do Orçamento] LEFT JOIN
	(SELECT DISTINCT [Pedido de Venda].Número, REPLACE(STR([Pedido de Venda].[Número do Orçamento], 8, 0), ' ', '0') AS [Número do Orçamento] FROM [Pedido de Venda] WITH (NOLOCK)) AS [Pedido de Venda] ON [Pedido de Venda].[Número do Orçamento] = REPLACE(STR(GPIMAC_Altamira.dbo.[View_LaOrVAgrupadoAux01].VwLo0Ped, 8, 0), ' ', '0')




























