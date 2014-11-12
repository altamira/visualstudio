
-------------------------------------------------------------------------------
--pr_admissao_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Funcionários Admitidos                   
--Data             : 07/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_admissao_funcionario
as
Select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  f.dt_admissao_funcionario,
  f.cd_centro_custo,
  f.cd_departamento,
  f.cd_categoria_salario,
  f.cd_cargo_funcionario,
  cs.nm_categoria_salario,
  gs.nm_grupo_salario,
  cs.vl_categoria_salario,
  (select fe.vl_funcionario_evento from funcionario_evento fe where fe.cd_funcionario = f.cd_funcionario) as vl_salario_funcionario,  
  (select cs.vl_composicao_salarial From composicao_salarial cs
  where getdate() between cs.dt_inicial and cs.dt_final and
  cs.cd_departamento = f.cd_departamento and 
  cs.cd_cargo_funcionario = f.cd_cargo_funcionario) as vl_composicao_salarial,
  d.nm_departamento,
  cc.nm_centro_custo
From
  Funcionario f
  left outer join Funcionario_Informacao fi on fi.cd_funcionario = f.cd_funcionario
  left outer join Departamento d on d.cd_departamento = f.cd_departamento
  left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
  left outer join Categoria_Salario cs on cs.cd_categoria_salario = f.cd_categoria_salario
  left outer join Grupo_Salario gs on gs.cd_grupo_salario = cs.cd_grupo_salario
where fi.dt_demissao is null
order by f.dt_admissao_funcionario
