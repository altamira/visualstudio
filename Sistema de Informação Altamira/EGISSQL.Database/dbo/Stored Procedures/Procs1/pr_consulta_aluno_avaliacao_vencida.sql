
-------------------------------------------------------------------------------
--pr_consulta_aluno_avaliacao_vencida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Alunos com Mensalidades em Atraso
--Data             : 19.02.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_aluno_avaliacao_vencida
@dt_inicial datetime,
@dt_final   datetime
as

select
  a.cd_aluno                                                   as Codigo,
  a.nm_aluno                                                   as Aluno,
  cast( a.cd_ddd_celular + a.cd_celular_aluno as varchar(15) ) as Celular,
  sa.nm_status_aluno                                           as Status,
  pa.nm_plano                                                  as Plano,
  ta.nm_tipo_avaliacao                                         as Avaliacao,
  aa.dt_vencimento_avaliacao                                   as DataVencimento,
  cast( getdate() - aa.dt_vencimento_avaliacao as int )        as Dias
from
  aluno a
  left outer join Aluno_Plano            ap on ap.cd_aluno           = a.cd_aluno
  left outer join Plano_Academia         pa on pa.cd_plano           = ap.cd_plano
  left outer join status_aluno           sa on sa.cd_status_aluno    = a.cd_status_aluno
  inner join      Aluno_Avaliacao        aa on aa.cd_aluno           = a.cd_aluno
  left outer join Tipo_Avaliacao_Aluno   ta on ta.cd_tipo_avaliacao  = aa.cd_tipo_avaliacao
where
  aa.dt_vencimento_avaliacao < getdate()
order by
  aa.dt_vencimento_avaliacao,
  a.nm_aluno

--select * from aluno_avaliacao

--select * from aluno

--select * from Aluno_Parcela
--select * from aluno_acesso

