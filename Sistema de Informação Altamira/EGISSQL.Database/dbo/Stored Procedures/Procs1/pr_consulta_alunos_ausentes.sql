
-------------------------------------------------------------------------------
--pr_consulta_alunos_ausentes
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Alunos Ausentes
--Data             : 19.02.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_alunos_ausentes
@dt_inicial datetime,
@dt_final   datetime
as

select
  a.cd_aluno                                                   as Codigo,
  a.nm_aluno                                                   as Aluno,
  cast( a.cd_ddd_celular + a.cd_celular_aluno as varchar(15) ) as Celular,
  sa.nm_status_aluno                                           as Status,
  pa.nm_plano                                                  as Plano,
 ( select top 1 dt_acesso from aluno_acesso aa where aa.cd_aluno = a.cd_aluno order by dt_acesso desc ) as UltimoAcesso, 
 cast( getdate() - ( select top 1 dt_acesso from aluno_acesso aa where aa.cd_aluno = a.cd_aluno order by dt_acesso desc ) as int ) as Dias
from
  aluno a
  left outer join Aluno_Plano            ap on ap.cd_aluno           = a.cd_aluno
  left outer join Plano_Academia         pa on pa.cd_plano           = ap.cd_plano
  left outer join status_aluno           sa on sa.cd_status_aluno    = a.cd_status_aluno
order by
  a.nm_aluno

--select * from Aluno_Parcela
--select * from aluno_acesso

