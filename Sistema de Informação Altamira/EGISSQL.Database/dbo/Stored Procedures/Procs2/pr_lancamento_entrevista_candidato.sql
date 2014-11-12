
CREATE PROCEDURE pr_lancamento_entrevista_candidato
AS
Select
  e.cd_entrevista,
  e.dt_entrevista,
  e.cd_requisicao_vaga,
  e.cd_tipo_entrevista,
  e.cd_candidato,
  e.hr_inicio_entrevista,
  e.hr_fim_entrevista,
  e.ds_entrevista,
  e.ic_lembrete_entrevista,
  e.nm_obs_entrevista,
  e.dt_agenda_entrevista,
  e.dt_cancelamento,
  e.cd_usuario,
  e.dt_usuario,
  te.nm_tipo_entrevista,
  c.nm_candidato,
  rv.cd_requisicao_vaga
From 
  Entrevista e
  left outer join tipo_entrevista te on te.cd_tipo_entrevista = e.cd_tipo_entrevista 
  left outer join Candidato c on c.cd_candidato = e.cd_candidato
  left outer join Requisicao_Vaga rv on rv.cd_requisicao_vaga = e.cd_requisicao_vaga
