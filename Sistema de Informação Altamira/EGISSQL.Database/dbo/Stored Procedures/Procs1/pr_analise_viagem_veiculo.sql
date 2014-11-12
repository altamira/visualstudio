
-------------------------------------------------------------------------------
--pr_analise_viagem_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 30.08.2005
--Atualizado       : 30.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_viagem_veiculo
@dt_inicial datetime,
@dt_final   datetime
as

--select * from requisicao_viagem
--select * from veiculo

select
  v.nm_veiculo                          as Veiculo,
  v.cd_placa_veiculo                    as Placa,
  m.nm_moeda                            as Moeda,
  max(rv.dt_requisicao_viagem)          as InicioViagem,
  max(rv.dt_fim_viagem)                 as FimViagem,
  sum(isnull(rv.vl_total_viagem,0))     as Total,
  sum(isnull(rv.vl_adto_viagem,0))      as Adiantamento,
  sum(isnull(rv.vl_despesa_viagem,0))   as Despesa,
  sum(isnull(rv.vl_reembolso_viagem,0)) as Reembolso,
  sum(isnull(rv.vl_cartao_viagem,0))    as Cartao
from
  Requisicao_Viagem rv 
  inner join Veiculo        v  on v.cd_veiculo         = rv.cd_veiculo
  left outer join Moeda          m  on m.cd_moeda           = rv.cd_moeda
Group by
   v.nm_veiculo,                          
   v.cd_placa_veiculo,                   
   m.nm_moeda
