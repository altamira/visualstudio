
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo de OS por Cliente
--Data             : 08/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_os_cliente
@dt_inicial datetime,
@dt_final   datetime

as

select
  mh.nm_empresa                 as Cliente,
  count(*)                      as 'TotalAberto',
  min(mh.dt_usuario)            as 'Primeira',
  max(mh.dt_usuario)            as 'Ultima',
  count(DISTINCT mh.cd_modulo)  as 'QtdModulo'
from
  Menu_historico mh
where
  mh.dt_usuario between @dt_inicial and @dt_final and
  isnull(mh.ic_status_menu,'N') = 'N'
group by 
  mh.nm_empresa
order by
  mh.nm_empresa

