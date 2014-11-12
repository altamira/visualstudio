
CREATE PROCEDURE pr_consulta_funcionario
@ic_parametro  int         = 0,
@nm_fantasia   varchar(50) = '',
@cd_usuario    int         = 0

--@ic_secretaria char(1)     = 'N'

AS

--Montagem da Tabela Auxiliar de Funcionários para Consulta

--select * from situacao_funcionario

  Select 
    f.nm_foto_funcionario,
    f.cd_ddd_funcionario,
    f.cd_telefone_funcionario,
    f.cd_empresa,
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_chapa_funcionario,
    f.cd_usuario,
    f.dt_usuario,
    f.cd_rg_funcionario,
    f.cd_cpf_funcionario,
    f.dt_admissao_funcionario,
    f.cd_departamento,
    f.dt_nascimento_funcionario,
    f.cd_cargo_funcionario,
    dp.nm_departamento,
    cf.nm_cargo_funcionario,
    f.cd_centro_custo,
    isnull(f.qt_limite_req_viagem,0) as qt_limite_req_viagem,
    cc.nm_centro_custo,
--     s.cd_secretaria,
--     s.nm_secretaria,
    ( select top 1 s.cd_secretaria from secretaria s where s.cd_funcionario = f.cd_funcionario ) as cd_secretaria,
    ( select top 1 s.nm_secretaria from secretaria s where s.cd_funcionario = f.cd_funcionario ) as nm_secretaria,

    case when isnull(dp.cd_assunto_viagem,0) > 0
    then 
     dp.cd_assunto_viagem
    else
      case when isnull(cc.cd_assunto_viagem,0) > 0
      then
        cc.cd_assunto_viagem
      else
        f.cd_assunto_viagem
      end
    end                                   as cd_assunto_viagem,
    isnull(f.cd_local_viagem,0)           as cd_local_viagem,
    isnull(stf.nm_setor_funcionario,'')   as nm_setor_funcionario,
    isnull(sf.nm_situacao_funcionario,'') as nm_situacao_funcionario

--select * from secretaria

  into
    #ConsultaFuncionario  

  from funcionario f                           with (nolock)
       left outer join Departamento dp         with (nolock) on (f.cd_departamento         = dp.cd_Departamento)
       left outer join cargo_funcionario cf    with (nolock) on (f.cd_cargo_funcionario    = cf.cd_cargo_funcionario)
       left outer join Centro_Custo cc         with (nolock) on cc.cd_centro_custo         = f.cd_centro_custo
--       left outer join Secretaria s            with (nolock) on s.cd_funcionario           = f.cd_funcionario
       left outer join Situacao_Funcionario sf with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario
       left outer join Setor_Funcionario   stf with (nolock) on stf.cd_setor_funcionario   = f.cd_setor_funcionario  
  where
    isnull(sf.ic_bloqueio_situacao,'N')='N'
 
--Verifica se o Usuário é Secretária---------------------------------------------------------

if @cd_usuario>0 
begin

  declare @cd_funcionario int

  select
    @cd_funcionario = isnull(cd_funcionario,0)
  from
    egisadmin.dbo.usuario
  where
    cd_usuario = @cd_usuario
   
  --select * from secretaria

  select
    cd_funcionario
  into
    #FuncionarioSecretaria
  from
    Secretaria with (nolock) 
  where
    cd_usuario_sistema = @cd_usuario

  insert into
    #FuncionarioSecretaria
  select
    @cd_funcionario


  --delete os funcinários que não são do grupo de secretárias

  delete from #ConsultaFuncionario where cd_funcionario not in ( select cd_funcionario from #FuncionarioSecretaria )


end




-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 --Consulta por Nome e CPF
-------------------------------------------------------------------------------------------
Begin
  Select 
    f.*
  from
    #ConsultaFuncionario f
  where (f.nm_funcionario like @nm_fantasia + '%')
  order by f.nm_funcionario

end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = 2 --Consulta Chapa
-------------------------------------------------------------------------------------------
Begin
  Select 
    f.*
  from
    #ConsultaFuncionario f

  where (f.cd_chapa_funcionario like @nm_fantasia + '%')
  order by
    f.cd_chapa_funcionario

end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = 3 --Consulta CPF
-------------------------------------------------------------------------------------------
Begin

  Select 
    f.*
  from
    #ConsultaFuncionario f
  where(f.cd_cpf_funcionario like @nm_fantasia + '%')
  order by
    f.cd_cpf_funcionario

end

drop table #ConsultaFuncionario 

