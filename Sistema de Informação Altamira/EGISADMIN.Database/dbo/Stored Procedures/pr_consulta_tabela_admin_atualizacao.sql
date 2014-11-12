
-------------------------------------------------------------------------------
--pr_consulta_tabela_admin_atualizacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Tabelas que devem ser configuradas para o 
--                   Processo de atualização 
--Data             : 21.06.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_tabela_admin_atualizacao
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

select
  t.cd_tabela       as Codigo,
  t.nm_tabela       as Tabela,
  t.ds_tabela       as Descricao,
  bd.nm_banco_dados as Banco
from
  Tabela t
  left outer join Banco_Dados bd on bd.cd_banco_dados = t.cd_banco_dados
where
  isnull(t.ic_versao_tabela,'N') = 'S'
order by
  t.nm_tabela
  

--select * from tabela

