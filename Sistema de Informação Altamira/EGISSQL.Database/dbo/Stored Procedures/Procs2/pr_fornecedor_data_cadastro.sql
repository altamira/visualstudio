

/****** Object:  Stored Procedure dbo.pr_fornecedor_data_cadastro    Script Date: 13/12/2002 15:08:31 ******/

--pr_fornecedor_data_cadastro
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es) : Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo  : Consulta de Fornecedores Novos.
--Atualização: 05/08/2002 - Passa a buscar dados da tabela fornecedor e não
--             mais da tabela fornecedor_endereço referentes ao endereço - ELIAS
---------------------------------------------------

CREATE PROCEDURE pr_fornecedor_data_cadastro

@data_inicial datetime

AS

select 
  f.cd_fornecedor,
  f.nm_fantasia_fornecedor as 'NomeFantasia',
  f.dt_cadastro_fornecedor as 'DataCadastro',
  f.cd_ddd as 'DDD',
  f.cd_telefone as 'Telefone',
  c.nm_cidade as 'Cidade',
  e.sg_estado as 'Estado',
  co.nm_comprador as 'Comprador',
  r.sg_ramo_atividade as 'RamoAtividade'
from
  Fornecedor f
left outer join
  Cidade c
on
  f.cd_cidade = c.cd_cidade
left outer join
  Estado e
on
  f.cd_estado = e.cd_estado
left outer join
  Comprador co
on
  f.cd_comprador = co.cd_comprador
left outer join
  Ramo_Atividade r
on
  r.cd_ramo_atividade = f.cd_ramo_atividade
where
  f.dt_cadastro_fornecedor between @data_inicial and getdate()  
order by
  DataCadastro desc,
  NomeFantasia



