
CREATE VIEW vw_fornecedor_exportacao
------------------------------------------------------------------------------------
--vw_fornecedor_exportacao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2006
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes / Márcio Rodrigues
--Banco de Dados	: EGISSQL
--Objetivo	        : Monta uma tabela de fornecedores para exportação - SAM
--Data                  : 04.04.2006
--Atualização           : 
------------------------------------------------------------------------------------
as
 
select
  cd_fornecedor          as CODIGO,
  nm_fantasia_fornecedor as FANTASIA,
  nm_razao_social        as FORNECEDOR,
  dt_cadastro_fornecedor as DTCADASTRO,
  ''                     as IDENTIFICACAO,
  cd_ramo_atividade,
  cd_tipo_mercado
from
  Fornecedor

