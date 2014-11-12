
CREATE VIEW vw_parametros_sistema
------------------------------------------------------------------------------------
--vw_parametros_sistema
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra a tabela de parâmetros
--Data                  : 20.04.2007
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.tabela
--select * from egisadmin.dbo.banco_dados
select
  bd.nm_fantasia_banco_dados,
  t.cd_tabela,
  t.nm_tabela,
  a.cd_atributo,
  a.nm_atributo
  
from
  egisadmin.dbo.tabela t                       with (nolock)
  inner join egisadmin.dbo.atributo a          with (nolock) on a.cd_tabela       = t.cd_tabela
  left outer join egisadmin.dbo.banco_dados bd with (nolock) on bd.cd_banco_dados = t.cd_banco_dados
where
  isnull(ic_parametro_tabela,'N')='S'
--order by
--  t.nm_tabela
