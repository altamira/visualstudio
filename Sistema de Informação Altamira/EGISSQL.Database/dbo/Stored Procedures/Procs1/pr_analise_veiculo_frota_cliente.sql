
-------------------------------------------------------------------------------
--pr_analise_veiculo_frota_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Licenças por Veículo
--Data             : 31.08.2005
--Atualizado       : 31.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_veiculo_frota_cliente
@dt_inicial datetime,
@dt_final   datetime
as

--select * from requisicao_viagem
--select * from veiculo
--select * from motorista

select 
  c.nm_fantasia_cliente                               as Cliente,
  cf.cd_frota                                         as Frota,
  gv.nm_grupo_veiculo                                 as Grupo,
  v.nm_veiculo                                        as Veiculo,
  v.cd_placa_veiculo                                  as Placa,
  isnull(mv.nm_motorista,mf.nm_motorista)             as Motorista
from
  Frota_Cliente cf 
  inner join Cliente            c  on c.cd_cliente        = cf.cd_cliente
  inner join Veiculo            v  on v.cd_veiculo        = cf.cd_veiculo
  left outer join Motorista     mv on mv.cd_veiculo       = cf.cd_veiculo
  left outer join Motorista     mf on mf.cd_motorista     = cf.cd_motorista
  left outer join Grupo_Veiculo gv on gv.cd_grupo_veiculo = v.cd_grupo_veiculo
order by
   c.nm_fantasia_cliente,
   cf.cd_frota


