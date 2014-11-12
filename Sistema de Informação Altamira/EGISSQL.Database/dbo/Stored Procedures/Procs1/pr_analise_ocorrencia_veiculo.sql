
-------------------------------------------------------------------------------
--pr_analise_ocorrencia_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Ocorrências no Controle Operacional
--Data             : 01/10/2003
--Atualizado       : 20.08.2005
--------------------------------------------------------------------------------
create procedure pr_analise_ocorrencia_veiculo
@dt_inicial datetime,
@dt_final   datetime
as

--select * from ocorrencia_veiculo
--select * from veiculo
--select 

select
  mov.nm_mot_ocorrencia_veiculo     as Ocorrencia,
  v.nm_veiculo                      as Veiculo,
  v.cd_placa_veiculo                as Placa,
  count( ov.cd_ocorrencia_veiculo ) as Total
into #Ocorrencia
from
  Ocorrencia_Veiculo ov
  left outer join Motivo_Ocorrencia_Veiculo mov on mov.cd_mot_ocorrencia_veiculo = ov.cd_mot_ocorrencia_veiculo
  left outer join Veiculo                   v   on v.cd_veiculo                  = ov.cd_veiculo
where
  ov.dt_ocorrencia_veiculo between @dt_inicial and @dt_final
Group by 
  mov.nm_mot_ocorrencia_veiculo,
  v.nm_veiculo,
  v.cd_placa_veiculo

declare @vl_total int

set @vl_total = 0

select @vl_total = sum( isnull(total,0) ) from #Ocorrencia

select
  *,
  Perc = (Total/@vl_total)*100
from
  #Ocorrencia
  
