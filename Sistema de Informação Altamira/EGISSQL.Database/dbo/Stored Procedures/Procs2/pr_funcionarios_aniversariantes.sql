
-------------------------------------------------------------------------------
--pr_funcionarios_aniversariantes
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Funcionários Aniversariantes
--Data             : 13/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_funcionarios_aniversariantes
@dt_inicial integer,
@dt_final integer
as
Select
   f.cd_funcionario,
   f.nm_funcionario,
   f.cd_chapa_funcionario,
   f.dt_nascimento_funcionario,
   d.nm_departamento
From
   Funcionario f 
   left outer join Departamento d on d.cd_departamento = f.cd_departamento
Where month(f.dt_nascimento_funcionario) between @dt_inicial and @dt_final
Order By f.nm_funcionario
