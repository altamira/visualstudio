
CREATE VIEW vw_hierarquia_funcionario_empresa

AS

  Select 
    isnull(fa.cd_funcionario,0)      as cd_funcionario_aprovacao,
    fa.nm_funcionario                as nm_funcionario_aprovacao,
    dp.nm_departamento,
    cc.nm_centro_custo,
    f.nm_funcionario,
    f.cd_empresa,
    isnull(f.cd_funcionario,0)       as cd_funcionario,
    f.cd_chapa_funcionario,
    f.cd_rg_funcionario,
    f.cd_cpf_funcionario,
    f.dt_admissao_funcionario,
    f.cd_departamento,
    f.dt_nascimento_funcionario,
    f.cd_cargo_funcionario,
    cf.nm_cargo_funcionario,
    f.cd_centro_custo,
    s.cd_secretaria,
    s.nm_secretaria,
    ta.qt_ordem_tipo_aprovacao,
    ta.nm_tipo_aprovacao,
    u.cd_usuario

--select * from tipo_aprovacao

  from funcionario f                           with (nolock)
       left outer join Departamento dp         with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
       left outer join cargo_funcionario cf    with (nolock) on (f.cd_cargo_funcionario    = cf.cd_cargo_funcionario)
       left outer join Centro_Custo cc         with (nolock) on cc.cd_centro_custo         = f.cd_centro_custo
       left outer join Secretaria s            with (nolock) on s.cd_funcionario           = f.cd_funcionario
       left outer join Situacao_Funcionario sf with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario
       left outer join 
       Departamento_aprovacao_funcionario daf  with (nolock) on daf.cd_departamento        = f.cd_departamento and
                                                                daf.cd_centro_custo        = f.cd_centro_custo
       left outer join Funcionario fa          with (nolock) on fa.cd_funcionario          = daf.cd_funcionario 
       left outer join Tipo_Aprovacao ta       with (nolock) on ta.cd_tipo_aprovacao       = daf.cd_tipo_aprovacao
       left outer join egisadmin.dbo.usuario u with (nolock) on u.cd_funcionario           = f.cd_funcionario
        
  where	
    isnull(sf.ic_bloqueio_situacao,'N')='N'

