
-------------------------------------------------------------------------------
--pr_consulta_alunos_acesso_bloqueado
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Alunos com Acesso Bloqueado
--Data             : 19.02.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_alunos_acesso_bloqueado
@dt_inicial datetime,
@dt_final   datetime
as

select
  a.cd_aluno                                                   as Codigo,
  a.nm_aluno                                                   as Aluno,
  cast( a.cd_ddd_celular + a.cd_celular_aluno as varchar(15) ) as Celular,
  sa.nm_status_aluno                  as Status,
  pa.nm_plano                         as Plano,
  ab.dt_bloqueio_acesso               as DataBloqueio,
  mb.nm_motivo_bloqueio               as Motivo,
  ab.nm_compl_bloqueio_acesso         as Complemento
from
  aluno a
  inner join Aluno_Bloqueio_Acesso       ab on ab.cd_aluno           = a.cd_aluno
  left outer join Motivo_Bloqueio_Acesso mb on mb.cd_motivo_bloqueio = ab.cd_motivo_bloqueio
  left outer join Aluno_Plano            ap on ap.cd_aluno           = a.cd_aluno
  left outer join Plano_Academia         pa on pa.cd_plano           = ap.cd_plano
  left outer join status_aluno           sa on sa.cd_status_aluno    = a.cd_status_aluno
     


