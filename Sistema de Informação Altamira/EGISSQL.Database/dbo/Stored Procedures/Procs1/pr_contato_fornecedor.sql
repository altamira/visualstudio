
-------------------------------------------------------------------------------
--pr_contato_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : José Ricardo Vano Junior
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Contatos de Fornecedores Inativos
--Data             : 19/05/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_contato_fornecedor
AS

SELECT 
  ForCon.cd_fornecedor,
  ForCon.nm_contato_fornecedor, 
  Departamento.nm_departamento,
  ForCon.dt_status_contato, 
  Fornecedor.nm_fantasia_fornecedor,  
  ForCon.cd_ddd_contato_fornecedor,
  ForCon.cd_telefone_contato_forne,
  ForCon.cd_ramal_contato_forneced,
  ForCon.cd_fax_contato_fornecedor,
  Forcon.cd_email_contato_forneced,
  ForCon.ic_status_contato,
  ForCon.dt_status_contato,
  ForCon.nm_fantasia_fornecedor

FROM 
  Fornecedor_Contato ForCon
  LEFT JOIN Fornecedor   on (Fornecedor.cd_fornecedor       = ForCon.cd_fornecedor)
  LEFT JOIN Departamento on (Departamento.cd_departamento   = ForCon.cd_departamento)
WHERE 
  isnull(ForCon.ic_status_contato,'A') = 'I'
ORDER BY 
  ForCon.dt_status_contato desc
