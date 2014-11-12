
CREATE PROCEDURE pr_consulta_cadastro_funcionario
@ic_parametro int         = 1,
@nm_fantasia  varchar(50) = ''

AS

--Tabelas de Funcionário
--select * from funcionario_documento
--select * from funcionario

-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 --Consulta por Nome 
-------------------------------------------------------------------------------------------
Begin
  Select 
    f.cd_empresa,
    f.cd_funcionario,
    f.nm_funcionario,
    f.nm_fantasia_funcionario,
    f.cd_chapa_funcionario,
    f.cd_usuario,
    f.dt_usuario,
    f.cd_rg_funcionario,
    f.cd_cpf_funcionario,
    f.dt_admissao_funcionario,
    f.cd_departamento,
    f.dt_nascimento_funcionario,
    f.cd_cargo_funcionario,
    f.nm_foto_funcionario,
    f.cd_ddd_funcionario,
    f.cd_telefone_funcionario,
    dp.nm_departamento,
    cf.nm_cargo_funcionario,
    cc.nm_centro_custo,
    f.dt_cadastro_funcionario,
    ts.nm_tipo_salario,
    cs.nm_categoria_salario,
    sf.nm_situacao_funcionario,
    cast( day(getdate()-f.dt_nascimento_funcionario) as int ) as Idade,
    t.nm_turno,
    f.cd_ddd_cel_funcionario,
    f.cd_cel_funcionario,
    fi.dt_proxima_ferias,
    fi.dt_solicitacao_ferias
  from 
    funcionario f   with (nolock)      
    left outer join Departamento         dp with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
    left outer join cargo_funcionario    cf with (nolock) on (f.cd_cargo_funcionario    = cf.cd_cargo_funcionario)
    left outer join Centro_Custo         cc with (nolock) on cc.cd_centro_custo         = f.cd_centro_custo
    left outer join Tipo_Salario         ts with (nolock) on ts.cd_tipo_salario         = f.cd_tipo_salario
    left outer join Categoria_Salario    cs with (nolock) on cs.cd_categoria_salario    = f.cd_categoria_salario
    left outer join Situacao_Funcionario sf with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario
    left outer join Turno                t  with (nolock) on t.cd_turno                 = f.cd_turno
    left outer join Funcionario_Informacao fi with (nolock) on fi.cd_funcionario         = f.cd_funcionario
  where (f.nm_funcionario like @nm_fantasia + '%')

end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = 2 --Consulta Chapa / Registro
-------------------------------------------------------------------------------------------
Begin
  Select 
    f.cd_empresa,
    f.cd_funcionario,
    f.nm_funcionario,
    f.nm_fantasia_funcionario,
    f.cd_chapa_funcionario,
    f.cd_usuario,
    f.dt_usuario,
    f.cd_rg_funcionario,
    f.cd_cpf_funcionario,
    f.dt_admissao_funcionario,
    f.cd_departamento,
    f.dt_nascimento_funcionario,
    f.cd_cargo_funcionario,
    f.nm_foto_funcionario,
    f.cd_ddd_funcionario,
    f.cd_telefone_funcionario,
    dp.nm_departamento,
    cf.nm_cargo_funcionario,
    cc.nm_centro_custo,
    f.dt_cadastro_funcionario,
    ts.nm_tipo_salario,
    cs.nm_categoria_salario,
    sf.nm_situacao_funcionario,
    cast( day(getdate()-f.dt_nascimento_funcionario) as int ) as Idade,
    t.nm_turno,
    f.cd_ddd_cel_funcionario,
    f.cd_cel_funcionario

  from 
    funcionario f                           with (nolock) 
    left outer join Departamento         dp with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
    left outer join cargo_funcionario    cf with (nolock) on (f.cd_cargo_funcionario    = cf.cd_cargo_funcionario)
    left outer join Centro_Custo         cc with (nolock) on cc.cd_centro_custo         = f.cd_centro_custo
    left outer join Tipo_Salario         ts with (nolock) on ts.cd_tipo_salario         = f.cd_tipo_salario
    left outer join Categoria_Salario    cs with (nolock) on cs.cd_categoria_salario    = f.cd_categoria_salario
    left outer join Situacao_Funcionario sf with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario
    left outer join Turno                t  with (nolock) on t.cd_turno                 = f.cd_turno

  where (cd_chapa_funcionario like @nm_fantasia + '%')

end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = 3 --Consulta CPF
-------------------------------------------------------------------------------------------
Begin
  Select 
    f.cd_empresa,
    f.cd_funcionario,
    f.nm_funcionario,
    f.nm_fantasia_funcionario,
    f.cd_chapa_funcionario,
    f.cd_usuario,
    f.dt_usuario,
    f.cd_rg_funcionario,
    f.cd_cpf_funcionario,
    f.dt_admissao_funcionario,
    f.cd_departamento,
    f.dt_nascimento_funcionario,
    f.cd_cargo_funcionario,
    f.nm_foto_funcionario,
    f.cd_ddd_funcionario,
    f.cd_telefone_funcionario,
    dp.nm_departamento,
    cf.nm_cargo_funcionario,
    cc.nm_centro_custo,
    f.dt_cadastro_funcionario,
    ts.nm_tipo_salario,
    cs.nm_categoria_salario,
    sf.nm_situacao_funcionario,
    cast( day(getdate()-f.dt_nascimento_funcionario) as int ) as Idade,
    t.nm_turno,
    f.cd_ddd_cel_funcionario,
    f.cd_cel_funcionario


  from 
    funcionario f                           with (nolock) 
    left outer join Departamento         dp with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
    left outer join cargo_funcionario    cf with (nolock) on (f.cd_cargo_funcionario    = cf.cd_cargo_funcionario)
    left outer join Centro_Custo         cc with (nolock) on cc.cd_centro_custo         = f.cd_centro_custo
    left outer join Tipo_Salario         ts with (nolock) on ts.cd_tipo_salario         = f.cd_tipo_salario
    left outer join Categoria_Salario    cs with (nolock) on cs.cd_categoria_salario    = f.cd_categoria_salario
    left outer join Situacao_Funcionario sf with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario
    left outer join Turno                t  with (nolock) on t.cd_turno                 = f.cd_turno

  where(f.cd_cpf_funcionario like @nm_fantasia + '%')

end

