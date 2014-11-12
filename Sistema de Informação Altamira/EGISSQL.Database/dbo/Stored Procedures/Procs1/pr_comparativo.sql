
-------------------------------------------------------------------------------
--pr_comparativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Comparativo de Valores / Quantidade 
--Data             : 06.06.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_comparativo
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

select
  cd_comparativo,
  nm_comparativo,
  vl_total,
  vl_comparativo,
  vl_diferenca,
  pc_evolucao_total,
  qt_total,
  qt_comparativo,
  qt_diferenca,
  pc_evolucao_quantidade,
  cd_posicao_atual,
  cd_posicao_anterior,
  nm_obs_comparativo,
  cd_localizacao
 
from
  Comparativo
order by
  vl_total desc
   

