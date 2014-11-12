
-------------------------------------------------------------------------------
--pr_analise_licenca_veiculo
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
create procedure pr_analise_licenca_veiculo
@dt_inicial datetime,
@dt_final   datetime
as

--select * from requisicao_viagem
--select * from veiculo

select 
  v.nm_veiculo                                        as Veiculo,
  v.cd_placa_veiculo                                  as Placa,
  tl.nm_tipo_licenca                                  as TipoLicenca,
  vl.dt_emissao_licenca                               as Emissao,
  vl.dt_vencimento_licenca                            as Vencimento,
  cast( getdate() - vl.dt_vencimento_licenca as int ) as Dia,
  case when cast( getdate() - vl.dt_vencimento_licenca as int )>0 then 'Vencida' else '' end as Status
from
  Veiculo_Licenca vl
  inner join Veiculo           v  on v.cd_veiculo       = vl.cd_veiculo
  left outer join tipo_licenca tl on tl.cd_tipo_licenca = vl.cd_tipo_licenca
order by
   v.nm_veiculo,                          
   v.cd_placa_veiculo                 


