
-------------------------------------------------------------------------------
--pr_analise_consumo_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Consumo de Abastecimento de Veículos
--Data             : 01/10/2003
--Atualizado       : 20.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_consumo_veiculo
@dt_inicial datetime,
@dt_final   datetime
as

--select * from movimento_veiculo
--select * from veiculo
--select 

select
  v.nm_veiculo                                      as Veiculo,
  m.nm_motorista                                    as Motorista,
  tc.nm_tipo_combustivel                            as Combustivel,
  mv.qt_movimento_veiculo                           as Consumo,
  mv.dt_movimento_veiculo                           as Ultimo,
  mv.qt_movimento_veiculo * mv.vl_movimento_veiculo as Total
into #Consumo
from
  Movimento_Veiculo mv
  left outer join Veiculo              v   on v.cd_veiculo                = mv.cd_veiculo
  left outer join Motorista            m   on m.cd_motorista              = mv.cd_motorista
  left outer join Tipo_Combustivel     tc  on tc.cd_tipo_combustivel      = mv.cd_tipo_combustivel
  left outer join Tipo_Servico_Veiculo tsv on tsv.cd_tipo_servico_veiculo = mv.cd_tipo_servico_veiculo
where
  mv.dt_movimento_veiculo between @dt_inicial and @dt_final and
  isnull(ic_analise_consumo,'N') = 'S'

select
  Veiculo,
  Combustivel,
  sum(isnull(Consumo,0)) as Consumo,
  sum(isnull(Total,0))   as Total,
  max(Ultimo)            as Ultimo,
  max(Motorista)         as Motorista
  
from
 #Consumo
group by
 Veiculo,
 Combustivel
  
