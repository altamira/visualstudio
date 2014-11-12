
-------------------------------------------------------------------------------
--pr_demissao_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Funcionários Demitidos
--Data             : 11/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_demissao_funcionario
as
Select
  f.cd_funcionario,
  f.nm_funcionario,
  f.cd_chapa_funcionario,
  fi.dt_demissao,
  md.nm_motivo_demissao,
  f.cd_centro_custo,
  f.cd_departamento,
  f.cd_categoria_salario,
  f.cd_cargo_funcionario,
  cs.nm_categoria_salario,
  gs.nm_grupo_salario,
  cs.vl_categoria_salario,
  (select fe.vl_funcionario_evento from funcionario_evento fe where fe.cd_funcionario = f.cd_funcionario) as vl_salario_funcionario,  
  null as nm_faixa_salarial,
  d.nm_departamento,
  cc.nm_centro_custo
From
  Funcionario f
  left outer join Funcionario_Informacao fi on fi.cd_funcionario = f.cd_funcionario
  left outer join Departamento d on d.cd_departamento = f.cd_departamento
  left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
  left outer join Categoria_Salario cs on cs.cd_categoria_salario = f.cd_categoria_salario
  left outer join Grupo_Salario gs on gs.cd_grupo_salario = cs.cd_grupo_salario
  left outer join motivo_Demissao md on md.cd_motivo_demissao = fi.cd_motivo_demissao
where fi.dt_demissao is not null
order by fi.dt_demissao
