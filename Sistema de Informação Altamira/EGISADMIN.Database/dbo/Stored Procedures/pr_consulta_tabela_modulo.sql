
-------------------------------------------------------------------------------
--pr_consulta_tabela_modulo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de Tabelas por Módulo
--Data             : 23/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_tabela_modulo
@dt_inicial datetime,
@dt_final   datetime

as

select 
  m.sg_modulo            as Sigla,
  m.nm_modulo            as Modulo,
  t.nm_tabela            as Tabela,
  t.ds_tabela            as Descricao,
  t.ic_inativa_tabela    as Inativa,
  t.ic_nucleo_tabela     as Nucleo,
  Banco = case when isnull(ic_sap_admin,'N') = 'S' then 'EGISADMIN' 
                                                   else 'EGISSQL' end

from
  Modulo m, Modulo_Tabela mt, Tabela t
where
  m.cd_modulo = mt.cd_modulo and
 mt.cd_tabela = t.cd_tabela
order by
 m.sg_modulo,
 t.nm_tabela

--select * from tabela

