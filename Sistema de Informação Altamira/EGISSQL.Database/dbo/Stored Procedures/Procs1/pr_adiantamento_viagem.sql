
-------------------------------------------------------------------------------
--pr_adiantamento_viagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Rafael Santiago
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 08/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_adiantamento_viagem

@dt_inicial as datetime,
@dt_final as datetime


as
select
  pv.nm_projeto_viagem as 'Projeto',
  rv.dt_requisicao_viagem as 'Data',
  d.nm_departamento as 'Departamento',
  f.nm_funcionario as 'Funcionario',
  m.sg_moeda as 'Moeda',
  rv.vl_adto_viagem as 'Valor'
from 
  Requisicao_Viagem rv 
  left outer join
  Projeto_Viagem pv on rv.cd_projeto_viagem = pv.cd_projeto_viagem
  left outer join 
  Departamento d on rv.cd_departamento = d.cd_departamento
  left outer join 
  Funcionario f on rv.cd_funcionario = f.cd_funcionario
  left outer join
  Moeda m on rv.cd_moeda = m.cd_moeda

