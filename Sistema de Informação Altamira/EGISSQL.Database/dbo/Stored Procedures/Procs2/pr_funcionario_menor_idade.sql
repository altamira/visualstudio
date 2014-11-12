
-------------------------------------------------------------------------------
--pr_funcionario_menor_idade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Funcionários Menores de Idade
--Data             : 13/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_funcionario_menor_idade
as
declare @bisexto 	varchar(5)
set @bisexto =	isnull((select top 1(cast(year(getdate())as int) - 
		cast(year(dt_nascimento_funcionario) as varchar)) from funcionario),0)

Select
   f.cd_funcionario,
   f.nm_funcionario,
   f.cd_chapa_funcionario,
   f.dt_admissao_funcionario,
   f.dt_nascimento_funcionario,
   cast	(((cast(getdate()as int) - cast(f.dt_nascimento_funcionario as int))/
			(365 + (@bisexto/4))) as int) as Idade,
   d.nm_departamento,
   cc.nm_centro_custo
From
   Funcionario f
   left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
   left outer join Departamento d on d.cd_departamento = f.cd_departamento
Where    cast	(((cast(getdate()as int) - cast(f.dt_nascimento_funcionario as int))/
			(365 + (@bisexto/4))) as int) < 18
Order By f.nm_funcionario
