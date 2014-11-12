
-------------------------------------------------------------------------------
--pr_mapa_financeiro_oportunidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Mapa Financeiro de Oportunidades
--                   
--Data             : 06.04.2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_mapa_financeiro_oportunidade
@dt_inicial datetime,
@dt_final   datetime
--@cd_usuario int

as

--select * from local_oficina
--select * from servico_veiculo
--select * from mao_obra
--Select * from oportunidade_agenda

select
  lo.nm_local_oficina                         as LocalOficina,
  sv.nm_servico                               as Servico,
  sv.qt_hora_servico_veiculo                  as Hora,
  mo.vl_mao_obra                              as Preco,
  sv.qt_hora_servico_veiculo * mo.vl_mao_obra as Total
from
  oportunidade_agenda oa
  left outer join Local_Oficina lo   on lo.cd_local_oficina = oa.cd_local_oficina
  left outer join Servico_Veiculo sv on sv.cd_servico       = oa.cd_servico
  left outer join Mao_Obra mo        on mo.cd_mao_obra      = sv.cd_mao_obra
where
  oa.dt_oportunidade_agenda between @dt_inicial and @dt_final



