
CREATE PROCEDURE pr_consulta_funcionario_exame_medico
@nm_fantasia varchar(50)

AS

  Select 
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_usuario,
    f.dt_usuario,
    f.dt_admissao_funcionario,
    f.cd_departamento,
    dp.nm_departamento,
    fem.dt_exame_funcionario,
    fem.dt_ultimo_exame,
   (fem.dt_ultimo_exame - GetDate()) as Dias,
    case when fem.dt_exame_funcionario <= GetDate() then 'Vencido'
    else 'Vencer' end as Status 

  from funcionario f left outer join 
       Departamento dp on (f.cd_departamento = dp.cd_Departamento) left outer join
       funcionario_exame_medico fem on (f.cd_funcionario = fem.cd_funcionario)
  where
   (f.nm_funcionario like @nm_fantasia + '%')

