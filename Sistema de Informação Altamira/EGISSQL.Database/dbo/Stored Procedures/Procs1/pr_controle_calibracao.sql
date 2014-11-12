
-------------------------------------------------------------------------------
--sp_helptext pr_controle_calibracao
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Calibração
--Data             : 10.12.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_controle_calibracao
@cd_ferramenta int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--select * from ferramenta

select
  --ic_atraso,
  f.cd_ferramenta,
  gf.nm_grupo_ferramenta,
  f.nm_fantasia_ferramenta,
  f.nm_ferramenta,
  f.cd_identificacao_ferramenta,
  gf.nm_grupo_ferramenta,
  f.nm_obs_ferramenta,
  lf.nm_local_ferramenta,
  tf.nm_tipo_ferramenta
from
  Ferramenta f                        with (nolock) 
  left outer join Grupo_Ferramenta gf with (nolock) on gf.cd_grupo_ferramenta = f.cd_grupo_ferramenta
  left outer join Local_Ferramenta lf with (nolock) on lf.cd_local_ferramenta = f.cd_local_ferramenta
  left outer join Tipo_Ferramenta  tf with (nolock) on tf.cd_tipo_ferramenta  = f.cd_tipo_ferramenta
where
  isnull(tf.ic_calibracao_tipo_ferramenta,'N')='S'
order by
  f.nm_fantasia_ferramenta

