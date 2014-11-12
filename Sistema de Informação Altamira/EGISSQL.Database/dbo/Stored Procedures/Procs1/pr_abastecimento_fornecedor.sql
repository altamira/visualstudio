
-------------------------------------------------------------------------------
--sp_helptext pr_abastecimento_fornecedor
-------------------------------------------------------------------------------
--pr_abastecimento_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Abastecimento por Fornecedor
--Data             : 19.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_abastecimento_fornecedor
@cd_fornecedor int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--select * from ordem_abastecimento
--select * from veiculo
--select * from fornecedor
 
select
  oa.cd_fornecedor,
  oa.cd_veiculo,
  max(f.nm_fantasia_fornecedor)                                               as nm_fantasia_fornecedor,
  max(f.nm_razao_social)                                                      as nm_razao_social,
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
  left outer join fornecedor f with (nolock) on f.cd_fornecedor = oa.cd_fornecedor
  left outer join veiculo v    with (nolock) on v.cd_veiculo   = oa.cd_veiculo
where
  oa.cd_fornecedor = case when @cd_fornecedor = 0 then oa.cd_fornecedor else @cd_fornecedor end and
  oa.dt_ordem between @dt_inicial and @dt_final   
group by
  oa.cd_fornecedor,
  oa.cd_veiculo

