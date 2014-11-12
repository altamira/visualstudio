

/****** Object:  Stored Procedure dbo.pr_Produto_Fiscal    Script Date: 13/12/2002 15:08:10 ******/
CREATE PROCEDURE pr_Produto_Fiscal
AS
  
  --Deletando a Tabela para a atualizaçao da mesma
  Delete
    Produto_Fiscal
  --Inicio de Migraçao de Dados <Produto_Fiscal>
    --Linkando a tabela de Produtos da SMC com a do EGISSQL
    -- para a busca do novo código incremental do EGISSQL
  Select
    prode.cd_produto				as 'cd_produto',
    CAST(null as int) 				as 'cd_destinacao_produto',
    CAST(null as float)				as 'qt_aliquota_icms_produto',
    1						as 'cd_dispositivo_legal_ipi',
    CAST(null as int)				as 'cd_dispositivo_legal_icms',
    CAST(null as int)				as 'cd_tipo_produto',
    CASE prods.origemproduto
      When '0' Then 1
      When '1' Then 2
      When '2' Then 2
    End						as 'cd_procedencia_produto',
    CAST(clfe.cd_classificacao_fiscal as int)	as 'cd_classificacao_fiscal',
    CAST(null as int)				as 'cd_tributacao',
    0						as 'cd_usuario',
    GetDate()					as 'dt_usuario'
  Into
    #Produto_Fiscal
  From
    smc.dbo.Produto prods inner join produto prode on
      prods.codigo collate SQL_Latin1_General_CP1250_CI_AS = prode.nm_fantasia_produto
    left outer join Classificacao_Fiscal clfe on
      prods.classificacaofiscal collate SQL_Latin1_General_CP1250_CI_AS = clfe.cd_mascara_classificacao
  --Final da Migraçao de Dados <Produto_Fiscal>
  --Início da Inserçao de Dados <Produto_Fiscal>
  Insert into
    Produto_Fiscal
  Select
    *
  From
    #Produto_Fiscal
  --Início da Inserçao de Dados <Produto_Fiscal>
  --Drop Table<#Produto_Fiscal>
    Drop Table
      #Produto_Fiscal


