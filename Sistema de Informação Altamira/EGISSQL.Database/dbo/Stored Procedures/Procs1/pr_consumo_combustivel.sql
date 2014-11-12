
-------------------------------------------------------------------------------
--sp_helptext pr_consumo_combustivel
-------------------------------------------------------------------------------
--pr_consumo_combustivel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consumo de Combustível
--Data             : 19.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consumo_combustivel
@cd_veiculo    int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--select * from ordem_abastecimento
--select * from veiculo
--select * from fornecedor
 
select
  oa.cd_veiculo,
  max(v.nm_veiculo)                                                           as nm_veiculo,
  max(v.cd_placa_veiculo)                                                     as nm_placa_veiculo,
  max(v.aa_veiculo)                                                           as aa_veiculo,
  max(v.qt_consumo_veiculo)                                                   as qt_consumo_veiculo,
  sum(isnull(oa.qt_abastecimento,0))                                          as qt_abastecimento,
  sum(isnull(oa.qt_abastecimento,0)  * isnull(vl_abastecimento,0))            as vl_total_abastecimento,
  
  sum((isnull(oa.qt_abastecimento,0) * isnull(vl_abastecimento,0))
      /
      case when isnull(oa.qt_abastecimento,0)>0
      then oa.qt_abastecimento 
      else 1 end)                                                              as vl_unitario,

  sum( isnull(oa.qt_km_atual_ordem,0) - isnull(qt_km_anterior_ordem,0))        as qt_percorrido,

  sum((isnull(oa.qt_km_atual_ordem,0) - isnull(qt_km_anterior_ordem,0))
      /
      case when isnull(oa.qt_abastecimento,0)>0
      then oa.qt_abastecimento 
      else 1 end)                                                             as qt_abastecimento

from
  ordem_abastecimento oa       with (nolock) 
  left outer join veiculo v    with (nolock) on v.cd_veiculo   = oa.cd_veiculo
where
  oa.cd_veiculo = case when @cd_veiculo = 0 then oa.cd_veiculo else @cd_veiculo end and
  oa.dt_ordem between @dt_inicial and @dt_final   
group by
  oa.cd_veiculo
order by
  v.nm_veiculo

