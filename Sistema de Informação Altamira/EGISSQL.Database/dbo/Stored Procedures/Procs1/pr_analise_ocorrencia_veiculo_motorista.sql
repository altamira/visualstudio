
-------------------------------------------------------------------------------
--pr_analise_ocorrencia_veiculo_motorista
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
create procedure pr_analise_ocorrencia_veiculo_motorista
@dt_inicial datetime,
@dt_final   datetime
as

--select * from ocorrencia_veiculo
--select * from veiculo
--select 

select
  mov.nm_mot_ocorrencia_veiculo  as Ocorrencia,
  count( cd_ocorrencia_veiculo ) as Total
from
  Ocorrencia_Veiculo ov
  left outer join Motivo_Ocorrencia_Veiculo mov on mov.cd_mot_ocorrencia_veiculo = ov.cd_mot_ocorrencia_veiculo
where
  ov.dt_ocorrencia_veiculo between @dt_inicial and @dt_final
Group by 
  mov.nm_mot_ocorrencia_veiculo

  
