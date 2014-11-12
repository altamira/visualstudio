
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo de OS por Módulo
--Data             : 07/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_os_modulo
@dt_inicial datetime,
@dt_final   datetime

as

select
  m.cd_modulo           as Modulo,
  max(m.sg_modulo)      as Sigla,
  count(*)              as 'TotalAberto',
  min(mh.dt_usuario)    as 'Primeira',
  max(mh.dt_usuario)    as 'Ultima',
  count(DISTINCT mh.nm_empresa)  as 'QtdCliente'
from
  Modulo m, 
  Menu_historico mh
where
  m.cd_modulo = mh.cd_modulo and
  mh.dt_usuario between @dt_inicial and @dt_final and
  isnull(mh.ic_status_menu,'N') = 'N'
group by 
  m.cd_modulo,
  m.sg_modulo
order by
  m.cd_modulo

