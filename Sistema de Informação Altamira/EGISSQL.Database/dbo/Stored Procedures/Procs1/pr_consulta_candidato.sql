
CREATE PROCEDURE pr_consulta_candidato
@ic_parametro int,
@nm_fantasia varchar(20),
@cd_fone varchar(8)

AS

--select * from cep
--drop table candidato
--select * from candidato
if @ic_parametro = 1 --nome fantasia
select
  c.cd_candidato,																		
  c.dt_candidato,
  c.nm_candidato,
  c.cd_cargo_funcionario,
  c.nm_email_candidato,  
  c.cd_grau_instrucao,     
  c.cd_sexo,
  c.cd_estado_civil,
  c.cd_cpf_candidato,
  c.cd_rg_candidato,
  c.dt_nascimento_candidato,
  c.ic_trabalhando_candidato,
  c.ic_confidencial_candidato ,
  c.vl_salario_candidato,                               
  cf.nm_cargo_funcionario,
  c.cd_ddd_candidato,
  c.cd_fone_candidato,
  c.cd_ddd_cel_candidato,
  c.cd_celular_candidato,
  c.nm_recado_candidato,
  c.nm_home_candidato,
  c.cd_cep,
  c.nm_endereco_candidato,
  c.nm_numero_endereco,
  c.nm_compl_endereco,
  c.nm_bairro_candidato,
  c.cd_pais,
  c.cd_estado,
  c.cd_cidade,
  c.cd_nivel_hierarquico,
  c.ds_cv_personalizado,
  c.nm_curriculum_candidato,
  c.nm_foto_candidato,
  c.ds_perfil_candidato,
  (cast(getdate() - c.dt_nascimento_candidato as integer) / 365) as Idade,    
  s.nm_sexo,
  gi.nm_grau_instrucao,
  c.cd_departamento,
  c.nm_arquivo_cv,
  c.cd_usuario,
  c.dt_usuario
from
  Candidato c
  left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = c.cd_cargo_funcionario
  left outer join Sexo s               on s.cd_sexo               = c.cd_sexo
  left outer join Grau_Instrucao gi    on gi.cd_grau_instrucao    = c.cd_grau_instrucao
where c.nm_candidato like case when isnull(@nm_fantasia,'') = '' then
                            c.nm_candidato
                          else
                            @nm_fantasia + '%'  
                          end 
else
if @ic_parametro = 2 --fone
select
  c.cd_candidato,																		
  c.dt_candidato,
  c.nm_candidato,
  c.cd_cargo_funcionario,
  c.nm_email_candidato,  
  c.cd_grau_instrucao,     
  c.cd_sexo,
  c.cd_estado_civil,
  c.cd_cpf_candidato,
  c.cd_rg_candidato,
  c.dt_nascimento_candidato,
  c.ic_trabalhando_candidato,
  c.ic_confidencial_candidato ,
  c.vl_salario_candidato,                               
  cf.nm_cargo_funcionario,
  c.cd_ddd_candidato,
  c.cd_fone_candidato,
  c.cd_ddd_cel_candidato,
  c.cd_celular_candidato,
  c.nm_recado_candidato,
  c.nm_home_candidato,
  c.cd_cep,
  c.nm_endereco_candidato,
  c.nm_numero_endereco,
  c.nm_compl_endereco,
  c.nm_bairro_candidato,
  c.cd_pais,
  c.cd_estado,
  c.cd_cidade,
  c.cd_nivel_hierarquico,
  c.ds_cv_personalizado,
  c.nm_curriculum_candidato,
  c.nm_foto_candidato,
  c.ds_perfil_candidato,
  (cast(getdate() - c.dt_nascimento_candidato as integer) / 365) as Idade,   
  s.nm_sexo,
  gi.nm_grau_instrucao,
  c.cd_departamento,
  c.nm_arquivo_cv,
  c.cd_usuario,
  c.dt_usuario
from
  Candidato c
  left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = c.cd_cargo_funcionario
  left outer join Sexo s               on s.cd_sexo               = c.cd_sexo
  left outer join Grau_Instrucao gi    on gi.cd_grau_instrucao    = c.cd_grau_instrucao
where 
  c.cd_fone_candidato like case when isnull(@cd_fone,'') = '' then
                             c.cd_fone_candidato
                           else
                             @cd_fone + '%'
                           end
