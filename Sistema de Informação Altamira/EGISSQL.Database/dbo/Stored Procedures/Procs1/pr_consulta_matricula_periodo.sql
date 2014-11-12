
-------------------------------------------------------------------------------
--pr_consulta_matricula_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Matrículas Efetuadas no Período
--Data             : 20.02.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_matricula_periodo
@dt_inicial datetime,
@dt_final   datetime
as

select
  a.cd_aluno                                                   as Codigo,
  a.nm_aluno                                                   as Aluno,
  cast( a.cd_ddd_celular + a.cd_celular_aluno as varchar(15) ) as Celular,
  sa.nm_status_aluno                                           as Status,
  pa.nm_plano                                                  as Plano,
  ap.dt_matricula_aluno                                        as DataMatricula,
  ap.vl_plano_aluno                                            as Valor
from
  aluno a
  left outer join Aluno_Plano            ap on ap.cd_aluno           = a.cd_aluno
  left outer join Plano_Academia         pa on pa.cd_plano           = ap.cd_plano
  left outer join status_aluno           sa on sa.cd_status_aluno    = a.cd_status_aluno
where
  ap.dt_matricula_aluno between @dt_inicial and @dt_final
order by
  ap.dt_matricula_aluno,
  a.nm_aluno

--select * from aluno_avaliacao

--select * from aluno
--select * from aluno_plano

--select * from Aluno_Parcela
--select * from aluno_acesso

