
-------------------------------------------------------------------------------
--sp_helptext pr_ordem_carregamento
-------------------------------------------------------------------------------
--pr_ordem_carregamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Ordem de Carregamento
--Data             : 04.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ordem_carregamento
@dt_inicial     datetime = '',
@dt_final       datetime = '',
@cd_ordem_carga int = 0 
as

select 
  oc.*,
  i.nm_itinerario,
  m.nm_motorista,
  v.nm_veiculo
from
  ordem_carregamento oc with (nolock)
  left outer join itinerario i on i.cd_itinerario = oc.cd_itinerario
  left outer join veiculo    v on v.cd_veiculo    = oc.cd_veiculo
  left outer join motorista  m on m.cd_motorista  = oc.cd_motorista
where
  ( oc.dt_ordem_carga between @dt_inicial and @dt_final ) and
  ( oc.cd_ordem_carga = case when @cd_ordem_carga = 0 then oc.cd_ordem_carga else @cd_ordem_carga end )  
