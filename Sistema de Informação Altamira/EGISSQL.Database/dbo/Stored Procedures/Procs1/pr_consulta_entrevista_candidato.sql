
CREATE PROCEDURE pr_consulta_entrevista_candidato
@nm_candidato varchar(20)
AS
Select
  e.cd_entrevista,
  e.dt_entrevista,
  e.hr_inicio_entrevista,
  e.hr_fim_entrevista,
  e.nm_obs_entrevista,
  te.nm_tipo_entrevista,
  c.nm_candidato,
  cast(c.cd_ddd_candidato + '-' + c.cd_fone_candidato as varchar(20)) as telefone, 
  cast(c.cd_ddd_cel_candidato + '-' + c.cd_celular_candidato as varchar(20)) as celular, 
  rv.cd_requisicao_vaga,
  cf.nm_cargo_funcionario
From 
  Entrevista e
  left outer join tipo_entrevista te on te.cd_tipo_entrevista = e.cd_tipo_entrevista 
  left outer join Candidato c on c.cd_candidato = e.cd_candidato
  left outer join Requisicao_Vaga rv on rv.cd_requisicao_vaga = e.cd_requisicao_vaga
  left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = c.cd_cargo_funcionario
Where 
  c.nm_candidato like case when isnull(@nm_candidato,'') = '' then
                        isnull(c.nm_candidato,'') + '%' 
                      else
                        isnull(@nm_candidato,'') + '%'
                      end 
Order By e.dt_entrevista 
