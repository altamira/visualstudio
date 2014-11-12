





CREATE VIEW [WBCCAD].[Orçamento]
AS
SELECT     
	CASE WHEN ISNUMERIC(orclst_numero) = 0 THEN '0' ELSE orclst_numero END AS [Número], 
	orclst_revisao						AS [Revisão], 
	orclst_revisao_orc					AS [Revisão Orçamento], 
	orclst_orcamento					AS [Orçamento], 
	orclst_pedido						AS [Número do Pedido], 
	CAST(orclst_cadastro AS DATE)		AS [Data do Cadastro], 
	CAST(orclst_emissao AS DATE)		AS [Data da Emissão], 
	ORCLSTDATAENTREGA					AS [Data da Entrega], 
	ORCLSTDATAULTATUALIZACAO			AS [Data da Última Atualização], 
	CAST(orclst_pedido_data AS DATE)	AS [Data do Pedido], 
	ORCLSTDATAFATURAMENTO				AS [Data do Faturamento], 
	orclst_dataImportacao				AS [Data da Importação], 
	CAST(orclst_data_email AS DATE)		AS [Data do Email], 
	orclst_versao_dat					AS [Data da Versão], 
	orclst_data_status					AS [Data da Situação], 
	orclst_status						AS [Situação], 
	(SELECT TOP 1 
		orcst.st_descricao 
	FROM 
		WBCCAD.DBO.ORCST 
	WHERE 
		Orcst.st_codigo = orclst_status) AS [Descrição da Situação],
	orclst_cli_codigo					AS [Código do Cliente], 
	orclst_cli_cgc_cpf					AS [CNPJ ou CPF], 
	orclst_cli_nome						AS [Nome], 
	orclst_cli_end_especie				AS [Espécie], 
	orclst_cli_end_endereco				AS [Endereço], 
	orclst_cli_end_numero				AS [Número do Endereço], 
	orclst_cli_end_complemento			AS [Complemento], 
	orclst_cli_end_bairro				AS [Bairro], 
	orclst_municipio					AS [Cidade], 
	orclst_uf							AS [Estado], 
	orclst_cli_end_cep					AS [CEP], 
	orclst_contato						AS [Nome do Contato], 
	orclst_email						AS [Email], 
	orclst_loja							AS [Loja], 
	orclst_area							AS [Area], 
	orclst_planta						AS [Planta], 
	orclst_corte						AS [Corte], 
	orclst_cli_bmp						AS [Bmp], 
	orclst_caminho_dwg					AS [Caminho do DWG], 
	CASE 
		WHEN orclst_nr_orc_vnd IS NULL 
		THEN ORCLST_VENDEDOR 
		ELSE orclst_nr_orc_vnd END		AS [Código do Representante], 
	orclst_opcao_comissao				AS [Percentual de Comissão], 
	COMISSAO_FATOR						AS [Fator], 
	orclst_lista						AS [Lista], 
	CAST(orclst_total AS MONEY)			AS [Total], 
	ORCLST_TOTAL_LISTA					AS [Total da Lista], 
	ORCLST_TOTAL1						AS [Total 1], 
	ORCLST_TOTAL2						AS [Total 2], 
	orclst_nova_reforma					AS [Nova Reforma], 
	orclst_motivo						AS [Motivo], 
	OrcLst_EmUsoPor						AS [Em Uso Por], 
	OrcLst_Computador					AS [Computador], 
	BANDEIRA, ORCLST_REFERENCIA			AS [Referencia], 
	ORCLST_IMPORTACAO_LISTA				AS [Importação Lista], 
	ORCLST_GERENTE						AS [Gerente], 
	ORCLST_VENDEDOR						AS [Vendedor], 
	ORCLST_PROJETISTA					AS [Projetista], 
	ORCLST_ORCAMENTISTA					AS [Orçamentista], 
	ORCLST_AGENTE						AS [Agente], 
	orclst_pedido_usuario				AS [Usuário do Pedido], 
	idOrcLst							AS [Id]
FROM         
	WBCCAD.dbo.Orclst
WHERE     
	(ISNUMERIC(orclst_numero) = 1)
	AND (CHARINDEX(orclst_numero, 'T') = 0) 
	





