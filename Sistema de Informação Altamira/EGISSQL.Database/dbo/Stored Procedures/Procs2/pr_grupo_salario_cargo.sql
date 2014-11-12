
-------------------------------------------------------------------------------
--pr_grupo_salario_cargo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Funções por Grupo de Salário
--Data             : 14/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_grupo_salario_cargo
as
Select
   f.cd_funcionario,
   gs.nm_grupo_salario,
   cs.nm_categoria_salario,
   d.nm_departamento,
   cc.nm_centro_custo,
   cf.nm_cargo_funcionario,
   cast(null as integer) as vl_salario_minimo,
   cast(null as integer) as vl_salario_maximo
From
   Funcionario f 
   left outer join Departamento d on d.cd_departamento = f.cd_departamento
   left outer join Categoria_Salario cs on cs.cd_categoria_salario = f.cd_categoria_salario
   left outer join Grupo_Salario gs on gs.cd_grupo_salario = cs.cd_grupo_salario
   left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
   left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = f.cd_cargo_funcionario
Order By f.nm_funcionario
