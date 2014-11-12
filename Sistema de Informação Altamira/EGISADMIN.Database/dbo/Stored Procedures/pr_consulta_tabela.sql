
-------------------------------------------------------------------------------
--pr_consulta_tabela
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de Tabelas 
--Data             : 24/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_tabela
@dt_inicial datetime,
@dt_final   datetime

as

select 
  t.cd_tabela             as Codigo,
  t.nm_tabela             as Tabela,
  t.ds_tabela             as Descricao,
  t.dt_criacao_tabela     as Data,
  t.ic_parametro_tabela   as Parametro,
  t.ic_implantacao_tabela as ZeraImplantacao,
  t.ic_fixa_tabela        as Fixa,
  t.ic_supervisor_altera  as Supervisor,
  t.ic_nucleo_tabela      as Nucleo,
  t.ic_inativa_tabela     as Inativa,
  pt.nm_prioridade_tabela as Prioridade,
  Banco = case when isnull(ic_sap_admin,'N') = 'S' then 'EGISADMIN' 
                                                   else 'EGISSQL' end,
  u.nm_fantasia_usuario   as Usuario

from
  Tabela t, 
  Prioridade_Tabela pt, 
  Usuario u
where
  t.cd_prioridade_tabela = pt.cd_prioridade_tabela and
  t.cd_usuario           = u.cd_usuario
order by
 t.nm_tabela

--select * from tabela

